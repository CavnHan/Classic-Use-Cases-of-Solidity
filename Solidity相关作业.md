

# Solidity相关作业

[TOC]



## 函数参数使用的时候有哪些注意到？

- 引用数据类型需要指明数据的存储位置：memory / calldata
- 函数的参数可以作为本地变量，也可用在等号左边被赋值
- 外部函数不支持多维数组，如果原文件加入 p `ragma abicoder v2;` 可以启用 ABI v2 版编码功能，这此功能可用。

## 创建一个utils合约，其中有sum方法，传入任意数量的数组，都可以用计算出求和结果

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
//传入一个任意大小的数组，计算求和结果
contract utils{
    function sumArray(uint256[] memory _data) public pure returns (uint256){
        uint256 total = 0;
        for (uint256 i = 0;i < _data.length;i++){
            total += _data[i];
        }
        return total;
    }

       function sumArray(int256[] memory _data) public pure returns (int256){
        int256 total = 0;
        for (uint256 i = 0;i < _data.length;i++){
            total += _data[i];
        }
        return total;
    }
}
```

## 函数可以定义在合约内部，也可以定义在外部，两种的区别是什么

- 内部函数：函数定义在内部，通常使用“private”、"internal"关键字，只能在合约内部或继承子合约中调用，不能被外部账户调用
- 外部函数：函数定义在合约内部，通常使用"external"关键字，可以被合约外部的账户和其他合约调用，也可用在合约 内部通过"this"关键字调用，在合约之外定义的函数仍然在合约的上下文内执行。他们仍然可以访问变量 `this` ，也可以调用其他合约，将其发送以太币或销毁调用它们合约等其他事情。与在合约中定义的函数的主要区别为：自由函数不能直接访问存储变量和不在他们的作用域范围内函数。

## 函数的构造函数有什么特点？

- 它仅能在智能合约部署的时候调用一次，创建之后不能再次调用，自动调用，不支持重载，不能通过this调用，可以接受参数，没有可见性修饰符，没有返回值

## 构造函数有哪些用途

- 用来设置管理账号，Token信息等可以自定义，并且以后永远不需要修改数据
- 可以用来做初始的权限设置，设置合约的所有者地址，用于访问控制避免后续没办法owner/admin地址
- 初始化状态变量，接受和处理初始资金，构造函数可以使用'paybale'修饰符，使其在合约部署时接收以太币
- 执行一次性设置，在构造函数中，可以部署其他合约并与之交互，这在需要嵌套合约或创建子合约的场景中很有用

## 合约内调用外部有哪些方式

- 使用表达式this.g(8);和c.g(2);其中c是合约实例，g为合约内实现的函数，这两种方式称为“外部调用”，通过消息调用，而不是直接的代码跳转

- 直接调用，指在一个内使用另一个合约的地址来调用其方式，通常需要知道目标合约的ABI(应用二进制接口)

  ```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.17;
  
  contract Callee {
      function getValue() external pure returns (uint256) {
          return 123;
      }
  }
  
  contract Caller {
      function callGetValue(address calleeAddress) public view returns (uint256) {
          Callee callee = Callee(calleeAddress);
          return callee.getValue();
      }
  }
  
  ```

  

- 使用接口，接口是一种声明合约中可用函数的方式。通过定义接口，可以更方便的与其他合约交互

  ```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.17;
  
  interface ICallee {
      function getValue() external view returns (uint256);
  }
  
  contract Caller {
      function callGetValue(address calleeAddress) public view returns (uint256) {
          ICallee callee = ICallee(calleeAddress);
          return callee.getValue();
      }
  }
  
  ```

- 使用call方法，是一种低级别的调用方法，允许向指定地址发送Ether并调用其函数，但也容易出错

  ```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.17;
  
  contract Caller {
      function callFunction(address calleeAddress, bytes memory data) public returns (bool, bytes memory) {
          (bool success, bytes memory returnData) = calleeAddress.call(data);
          require(success, "Call failed");
          return (success, returnData);
      }
  
      function callGetValue(address calleeAddress) public returns (uint256) {
          bytes memory data = abi.encodeWithSignature("getValue()");
          (bool success, bytes memory returnData) = calleeAddress.call(data);
          require(success, "Call failed");
          return abi.decode(returnData, (uint256));
      }
  }
  
  ```

  

## 从一个合约到另一个合约的函数调用会创建交易吗?

### 内部调用

- 在同一个合约中调用其他函数，或者从继承的父合约中调用函数
- 这类调用不会创建新的交易，都是在一个事务内完成的
- 内部调用使用’this.someFunction‘或直接调用’someFunction()'。

### 外部调用

- 从一个合约调用另一个独立合约中的函数
- 这种调用会产生内部交易，但不会像普通交易那样在区块链上直接记录
- 外部调用使用目标合约的地址和ABI,比如'otherContract.someFunction()'，或使用低级调用'call()'

### 内部交易和外部交易

- #### 内部交易

- 这是一个合约调用另一个合约时产生的操作。

- 内部交易不会直接在区块链上生成新的交易记录，但会反映在调用事务的执行过程中。

- 内部交易不会独立存在，它们是包含在外部交易中的一部分

- 内部交易不会消耗额外的Gas,但会增加原始交易的Gas消耗

- ### 外部交易

- 这是由外部账户(例如人类用户或外部应用程序)发起的交易

- 外部交易会在区块链上记录，并需要支付Gas费用

- 当外部交易调用合约中的函数时，该函数的执行可能会导致多个内部交易

## 调用函数并转账如何实现

- 定义一个合约B可以接收Ether并处理的函数

  ```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.17;
  
  contract B {
      uint256 public receivedAmount;
  
      function receiveEther() external payable {
          receivedAmount += msg.value;
      }
  
      function getBalance() external view returns (uint256) {
          return address(this).balance;
      }
  }
  
  ```

- 定义一个合约A，调用B的函数，并发送Ether

  ```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.17;
  
  contract A {
      address public bAddress;
  
      constructor(address _bAddress) {
          bAddress = _bAddress;
      }
  
      function callReceiveEther() external payable {
          // 使用低级调用发送 Ether 并调用 B 合约的 receiveEther 函数
          (bool success, ) = bAddress.call{value: msg.value,gas:800}(abi.encodeWithSignature("receiveEther()"));
          require(success, "Call failed");
      }
  
      function getBBalance() external view returns (uint256) {
          // 调用 B 合约的 getBalance 函数以查看 B 的余额
          (bool success, bytes memory data) = bAddress.staticcall(abi.encodeWithSignature("getBalance()"));
          require(success, "Call failed");
          return abi.decode(data, (uint256));
      }
  }
  
  ```

  

## extcodesize操作码会检查要调用的合约是否确实存在，有哪些特殊情况

extcodesize操作码在EVM中用于检查指定地址的代码大小，从而验证该地址是否为合约地址（代码大小不为零）或普通账户地址（代码大小为零）。然而，实际使用有几种特殊情况

- 低级 call 调用，会绕过检查
- 预编译合约的时候，也会绕过检查。
- 在合约创建过程中，如果使用 `CREATE` 或 `CREATE2` 操作码来部署新合约，在合约代码尚未完全部署（即，合约构造函数尚未执行完毕）之前，`extcodesize` 将返回零。这是因为新合约的代码只有在部署完成后才会存在。
- 如果一个合约执行了 `SELFDESTRUCT` 操作码，合约的代码和存储都会从区块链中删除。然而，区块链上仍然会保留该地址的记录。对该地址调用 `extcodesize` 将返回零，尽管该地址曾经是一个合约地址。
- 如果一个合约在其构造函数中调用自身，在构造函数完成之前，`extcodesize` 对该合约地址的调用将返回零。这是因为合约代码在构造函数执行完毕之前尚未完全部署。
- 代理合约模式允许合约通过 `DELEGATECALL` 调用其他合约的代码。代理合约本身可能没有代码或者只有少量的代码（比如一个简单的 `DELEGATECALL` 实现），但它的行为取决于它所代理的目标合约。对代理合约地址调用 `extcodesize` 可能返回一个很小的代码大小，尽管它的行为和逻辑是由目标合约决定的。

## 与其他合约交互的时候有什么需要注意到

- 任何与其他合约的交互都会产生潜在危险，尤其是在不能预先知道合约代码的情况下。

- ### 重入攻击防范

- 小心这个交互调用在返回之前再回调我们的合约，这意味着被调用合约可以通过它自己的函数改变调用合约的状态变量。 一个建议的函数写法是，例如，**在合约中状态变量进行各种变化后再调用外部函数**，这样，你的合约就不会轻易被滥用的重入攻击 (reentrancy) 所影响，重入攻击是智能合约中的一种常见漏洞，当合约在调用另一个合约时，没有正确处理外部调用返回前的状态更新，攻击者可以在调用返回前再次调用原始合约，造成不一致的状态或意外的行为。

  **防范方法**：

  - 使用 检查-效果-交互（Check-Effects-Interactions） 模式：在与外部合约交互前先进行状态更改，然后再执行外部调用。
  - 使用互斥锁（Mutex）或 `ReentrancyGuard` 合约（如 OpenZeppelin 提供的 ReentrancyGuard）

- ### 调用结果检查

- 与外部合约交互时，无比检查调用返回结果

  ```solidity
  (bool success, bytes memory data) = externalContract.call(abi.encodeWithSignature("someFunction()"));
  require(success, "External call failed");
  
  ```

- ### Gas限制

- 确保给外部合约调用分配足够的 Gas，同时避免给不受信任的合约提供过多的 Gas 以防止意外行为。

  ```solidity
  (bool success, ) = externalContract.call{gas: 100000}(abi.encodeWithSignature("someFunction()"));
  require(success, "External call failed");
  
  ```

- ### 合约地址的信任

- 在调用外部合约前，确保该合约的地址是可信任的。避免与不受信任的合约交互，以防止潜在的恶意行为。

- ### 调用模式

- 选择合约的调用模式

  1. `call`：常用于与外部合约交互，但要注意安全性。
  2. `delegatecall`：用于代理合约模式，调用目标合约时使用调用者的上下文。
  3. `staticcall`：用于静态调用，不允许状态修改。

- 权限控制

- 确保只有授权的用户或合约能够执行关键操作。使用 `modifier` 实现权限控制。

  ```solidity
  modifier onlyOwner() {
      require(msg.sender == owner, "Not authorized");
      _;
  }
  
  function sensitiveFunction() public onlyOwner {
      // Critical code here
  }
  
  ```

  

- ### 事件记录

- 在合约中记录关键操作的事件日志，以便将来可以跟踪和调试合约交互。

  ```solidity
  event Interaction(address indexed from, address indexed to, string action);
  
  function interact(address _to, string memory _action) public {
      emit Interaction(msg.sender, _to, _action);
      // Interaction code
  }
  
  ```

  

- ### 避免循环调用

- 避免在合约中进行递归调用或长时间运行的循环调用，这可能会导致 Gas 超出限制或其他不可预见的问题。

- ### 处理失败调用

- 妥善处理外部合约调用失败的情况，确保在调用失败时合约能恢复到一致状态。

- ### 审计和测试

- 在部署到生产环境之前，对合约进行全面的审计和测试，确保没有已知漏洞和意外行为。

  ```solidity
  pragma solidity ^0.8.0;
  
  import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
  
  contract InteractingContract is ReentrancyGuard {
      address public trustedContract;
  
      modifier onlyOwner() {
          require(msg.sender == owner, "Not authorized");
          _;
      }
  
      event Interaction(address indexed from, address indexed to, string action);
  
      constructor(address _trustedContract) {
          trustedContract = _trustedContract;
      }
  
      function setTrustedContract(address _trustedContract) public onlyOwner {
          trustedContract = _trustedContract;
      }
  
      function safeInteract() public nonReentrant {
          emit Interaction(msg.sender, trustedContract, "interact");
  
          (bool success, ) = trustedContract.call{value: msg.value, gas: 100000}(abi.encodeWithSignature("someFunction()"));
          require(success, "External call failed");
      }
  }
  
  ```

  

## public 既可以被当作内部函数也可以被当作外部函数。使用时候有什么注意的？

### 内部调用 vs 外部调用

1. **Gas 消耗**：
   - 内部调用是直接的函数调用，消耗较少的 Gas。
   - 外部调用是通过消息调用（message call），消耗更多的 Gas。
2. **访问控制**：
   - 确保 `public` 函数的逻辑安全，因为它可以被任何人调用。
   - 如果需要限制访问权限，使用修饰符（modifiers）进行权限控制，例如 `onlyOwner`。
3. **参数传递**：
   - 内部调用时，传递的参数不需要编码和解码，效率较高。
   - 外部调用时，传递的参数需要编码（ABI 编码），稍微复杂且消耗更多 Gas。
4. **返回值处理**：
   - 内部调用时，可以直接处理返回值。
   - 外部调用时，返回值通过交易返回，调用者需要解析返回的数据。

### 注意事项

1. **防止重入攻击**：

   - 当 `public` 函数进行外部调用（例如转账或调用外部合约）时，确保防止重入攻击。使用 `ReentrancyGuard` 或 `checks-effects-interactions` 模式。

2. **权限控制**：

   - 对于敏感操作，确保只有授权用户可以调用 `public` 函数。使用修饰符进行权限控制。

3. **避免意外调用**：

   - 如果函数仅用于内部逻辑，可以使用 `internal` 或 `private` 关键字。将不需要外部访问的函数设为 `internal` 或 `private`，可以防止意外调用。

4. **函数可见性**：

   - 在设计合约时，明确每个函数的访问权限。使用 `public` 仅在需要公开访问时，否则使用更严格的可见性（`internal`、`private`）。

     ```solidity
     // SPDX-License-Identifier: MIT
     pragma solidity ^0.8.0;
     
     import "@openzeppelin/contracts/access/Ownable.sol";
     import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
     
     contract Example is Ownable, ReentrancyGuard {
         uint256 public value;
     
         event ValueChanged(uint256 newValue);
     
         // Public function that can be called internally and externally
         function setValue(uint256 _value) public nonReentrant onlyOwner {
             value = _value;
             emit ValueChanged(_value);
         }
     
         // Internal function calling the public function
         function internalCall(uint256 _value) internal {
             setValue(_value);
         }
     
         // External function demonstrating internal and external calls
         function externalCall(uint256 _value) external {
             // Internal call
             internalCall(_value);
     
             // External call
             (bool success, ) = address(this).call(abi.encodeWithSignature("setValue(uint256)", _value + 1));
             require(success, "External call failed");
         }
     }
     
     ```

     

## pure 函数中，哪些行为被视为读取状态。

- 读取状态变量。
  - 这也意味着读取 `immutable` 变量也不是一个 `pure` 操作。
- 访问 `address(this).balance` 或 `<address>.balance`
- 访问 `block`，`tx`， `msg` 中任意成员 （除 `msg.sig` 和 `msg.data` 之外）。
- 调用任何未标记为 `pure` 的函数。

- 使用包含特定操作码的内联汇编。

  - `TODO:` 这个不了解，需要用例子加深印象。

- 使用操作码 `STATICCALL` , 这并不保证状态未被读取, 但至少不被修改。

- 读取合约余额，访问Address(this).balance

- 读取函数参数（引用类型）存储位置:  尝试读取传递给 `pure` 函数的参数，如果这些参数是存储引用类型（例如 `storage` 指针），也会被视为读取状态。

  ```solidity
  function modifyArray(uint256[] storage _array) public pure {
      _array[0] = 1; // This will cause an error because it reads the state
  }
  
  ```

  

## pure 函数发生错误时候，有什么需要注意的？

- 如果发生错误，`pure` 函数可以使用 `revert()` 和 `require()` 函数来还原潜在的状态更改。还原状态更改不被视为 **状态修改**, 因为它只还原以前在没有 `view` 或 `pure` 限制的代码中所做的状态更改, 并且代码可以选择捕获 revert 并不传递还原。这种行为也符合 STATICCALL 操作码。

## view 函数中，哪些行为视为修改状态。

- 修改状态变量。

- 触发事件。

- 创建其它合约。

- 使用 `selfdestruct`。

- 通过调用发送以太币。

- 调用任何没有标记为 view 或者 pure 的函数。

- 使用底层调用

  - (TODO:这里是 call 操作么？)

- 使用包含某些操作码的内联程序集。

- 调用非view或pure修饰的函数

- 修改局部存储变量的引用

  ```solidity
  struct Data {
      uint256 value;
  }
  
  Data public data;
  
  function modifyStruct() public view {
      Data storage d = data;
      d.value = 42; // 错误：修改结构中的值
  }
  
  ```

  

## pure/view/payable/这些状态可变性的类型转换是怎么样的？

- pure 函数可以转换为 view 和 non-payable 函数
- view 函数可以转换为 non-payable 函数
- payable 函数可以转换为 non-payable 函数
- 其他的转换则不可以。

## 使用 return 时，有哪些需要注意的？

- 函数返回类型不能为空 —— 如果函数类型不需要返回，则需要删除整个 `returns (<return types>)` 部分。
- 函数可能返回任意数量的参数作为输出。函数的返回值有两个关键字，一个是return,一个是return
  - `returns` 是在函数名后面的，用来标示返回值的数量，类型，名字信息。
  - `return` 是在函数主体内，用于返回 `returns` 指定的数据信息
- 如果使用 return 提前退出有返回值的函数， 必须在用 return 时提供返回值。
- 非内部函数有些类型没法返回，比如限制的类型有：多维动态数组、结构体等。
- 解构赋值一个函数返回多值时候，元素数量必须一样

## 函数的签名的逻辑是什么？为什么函数可以重载？

### 函数签名

1. **函数名称**：函数的名称是其签名的一部分，用于唯一标识函数。例如，对于函数 `function add(uint256 a, uint256 b)`，其名称是 `add`。
2. **参数列表**：参数列表包括参数的类型和顺序。Solidity 根据参数的类型和数量来生成函数的编码哈希值，这个哈希值也称为函数的签名。不同的参数列表会生成不同的签名。
3. **函数修饰符**：函数的修饰符（如 `public`、`external`、`internal`、`private`）以及状态可变性（如 `view`、`pure`、`payable`）也会影响函数的签名，尽管它们不会显式地出现在函数的编码中。

### 函数重载的原理

函数重载是指在同一个合约中定义多个函数，这些函数具有相同的名称但参数列表不同（包括参数类型或数量）。在 Solidity 中，函数可以重载的原因主要有两点：

1. **参数类型和数量的不同**：Solidity通过函数的参数列表来区分函数，如果两个函数的参数列表不同（包括参数类型、数量或顺序），它们将被编译成不同的函数签名。这允许在同一个合约中定义多个具有相同名称但不同参数的函数。
2. **编码哈希的唯一性**：每个函数的编码哈希是唯一的，这是由参数列表决定的。因此，即使两个函数具有相同的名称，只要它们的参数列表不同，它们就会被编译成不同的函数签名，从而实现函数重载的效果。

## 函数重载需要怎么样实现？

- **这些相同函数名的函数，参数(参数类型或参数数量)必须不一样。**，因为只有这样才能签出来不同的函数选择器。
- 如果两个外部可见函数仅区别于 Solidity 内的类型，而不是它们的外部类型则会导致错误。很难理解，需要看例子。

## 函数重载的参数匹配原理

在 Solidity 中，函数重载的参数匹配原理是基于函数的参数列表。函数的参数列表包括参数的类型、顺序和数量，这些因素共同决定了函数的唯一性。当定义多个具有相同名称但参数列表不同的函数时，Solidity 根据以下原则进行函数重载的参数匹配：

- **参数数量**：不同数量的参数会导致函数被编译成不同的函数签名。例如，一个函数接受两个参数，另一个接受三个参数，即使参数类型相同，它们也会被视为不同的函数。

- **参数类型**：如果参数列表中有一个或多个参数的类型不同，这也会导致函数被编译成不同的函数签名。例如，一个函数接受 `uint256` 和 `string` 类型的参数，另一个接受 `uint256` 和 `address` 类型的参数，它们会被视为不同的函数。

- **参数顺序**：参数顺序的不同也会导致函数被编译成不同的函数签名。即使参数类型相同，但参数顺序不同，也会被视为不同的函数。

- 通过将当前范围内的函数声明与函数调用中提供的参数相匹配，这样就可以选择重载函数。
- 如果所有参数都可以隐式地转换为预期类型，则该函数作为重载候选项。如果一个匹配的都没有，解析失败。
- 返回参数不作为重载解析的依据

## 下面的例子是合法的重载吗？

```solidity
`function f(uint8 val) public pure returns (uint8 out)` 和 `function f(uint256 val) public pure returns (uint256 out)`
```

 

- 不是的。
- 在 Remix 里,部署 A 合约，会将两个方法都渲染出来，调用 `f(50)`/`f(256)` 都可以。
- 但是实际调用里，在其他合约内调用 `f(50)` 会导致类型错误，因为 `50` 既可以被隐式转换为 `uint8` 也可以被隐式转换为 `uint256`。 另一方面，调用 `f(256)` 则会解析为 `f(uint256)` 重载，因为 `256` 不能隐式转换为 `uint8`。
- 为了避免类型错误，可以在调用函数时明确指定参数的类型。例如，调用 `f(uint8(50))` 或者 `f(uint256(50))` 来明确告知编译器应该调用哪个函数。

## 函数修饰器的意义是什么？有什么作用？

- **意义**:我们可以将一些通用的操作提取出来，包装为函数修改器，来提高代码的复用性，改善编码效率。是函数高内聚，低耦合的延伸。

- **作用**: `modifier` 常用于在函数执行前检查某种前置条件。

- 比如地址对不对，余额是否充足，参数值是否允许等

- 修改器内可以写逻辑

- **特点**: `modifier` 是一种合约属性，可被继承，同时还可被派生的合约重写(override)。（修改器 modifier 是合约的可继承属性，并可能被派生合约覆盖 , 但前提是它们被标记为 virtual）。

- `_` 符号可以在修改器中出现多次，每处都会替换为函数体。

- **代码重用和简化**：函数修饰器允许将通用的逻辑和验证条件抽取出来，并应用到多个函数中，从而提高代码的重用性和可维护性。通过减少重复代码，可以降低程序出错的概率。

  **增强安全性**：修饰器可以用于实现访问控制和权限管理。通过在函数调用前执行条件检查，如权限验证、状态检查等，可以确保函数只能被授权的用户或合约调用，从而提高合约的安全性。

  **逻辑分离**：修饰器允许将核心逻辑与辅助逻辑分离开来，使代码更易于理解和维护。通过将验证逻辑从业务逻辑中分离出来，可以提高代码的清晰度和可读性。

  **顺序执行**：修饰器可以链式调用，多个修饰器按照声明的顺序依次执行。这种特性使得可以灵活地组合和重用多个修饰器，以满足复杂的业务需求。

## Solidity 有哪些全局的数学和密码学函数？

- 数学函数：

- ```
  addmod(uint x, uint y, uint k) returns (uint)
  ```

  - 计算 `(x + y) % k`，加法会在任意精度下执行，并且加法的结果即使超过 `2**256` 也不会被截取。从 0.5.0 版本的编译器开始会加入对 `k != 0` 的校验（assert）。

- ```
  mulmod(uint x, uint y, uint k) returns (uint)
  ```

  - 计算 `(x * y) % k`，乘法会在任意精度下执行，并且乘法的结果即使超过 `2**256` 也不会被截取。从 0.5.0 版本的编译器开始会加入对 `k != 0` 的校验（assert）。

- 密码学函数：

- ```
  keccak256((bytes memory) returns (bytes32)
  ```

  - 计算 Keccak-256 哈希，之前 keccak256 的别名函数 **sha3** 在 **0.5.0** 中已经移除。。

- ```
  sha256(bytes memory) returns (bytes32)
  ```

  - 计算参数的 SHA-256 哈希。

- ```
  ripemd160(bytes memory) returns (bytes20)
  ```

  - 计算参数的 RIPEMD-160 哈希。

- ```
  ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)
  ```

  - 利用椭圆曲线签名恢复与公钥相关的地址，错误返回零值。
  - 函数参数对应于 ECDSA 签名的值:
    - r = 签名的前 32 字节
    - s = 签名的第 2 个 32 字节
    - v = 签名的最后一个字节
  - ecrecover 返回一个 address, 而不是 address payable