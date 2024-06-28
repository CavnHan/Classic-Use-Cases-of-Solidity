// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
ToDoList合约是类似便签一样功能的东西，记录我们需要做的事情，以及完成状态，需要的功能为：
1.创建任务
2.修改任务名称
3.修改完成状态：手动指定完成或者未完成
自动切换：如果未完成状态下，改为完成  如果完成状态，改为完成
4.获取任务
获取任务 2.思考代码内状态变量怎么安排？ 
思考 1：思考任务 ID 的来源？ 我们在传统业务里，这里的任务都会有一个任务 ID，在区块链里怎么实现？？ 
答：传统业务里，ID 可以是数据库自动生成的，也可以用算法来计算出来的，比如使用雪花算法计算出 ID 等。
在区块链里我们使用数组的 index 索引作为任务的 ID，也可以使用自增的整型数据来表示。 
思考 2: 我们使用什么数据类型比较好？ 答：因为需要任务 ID，如果使用数组 index 作为任务 ID。
则数据的元素内需要记录任务名称，任务完成状态，所以元素使用 struct 比较好。 如果使用自增的整型作为任务 ID，
则整型 ID 对应任务，使用 mapping 类型比较符合。
*/
contract TodoList {
    //定义任务
    struct Task {
        //任务名称
        string name;
        //任务状态，是否完成
        bool isCompiled;
    }
    //定义任务列表
    Task[] public list;

    //创建任务
    function createTask(string memory _name) external {
        // list.push(
        //     Task(
        //         {
        //             name:_name,
        //             isCompiled:false
        //         }
        //     )
        // );
        list.push(Task(_name, false));
    }

    modifier checkIndex(uint256 _index) {
        require(_index < list.length, "invalid index");
        _;
    }

    //修改任务名称
    function modiName(uint256 _index, string memory name)
        external
        checkIndex(_index)
    {
        //方式1
        // Task storage temp = list[_index];
        // temp.name = name;
        //方式2
        list[_index].name = name;
    }

    //修改完成状态
    function modiStatus(uint256 _index, bool status)
        external
        checkIndex(_index)
    {
        //手动
        // list[_index].isCompleted  = status;
        //自动切换
        list[_index].isCompiled = !list[_index].isCompiled;
    }

    //获取任务
    function getTask(uint256 _index)
        external
        view
        checkIndex(_index)
        returns (string memory name, bool status)
    {
        //         Task memory temp = list[_index];
        //         return (temp.name,temp.isCompiled);
        Task storage temp = list[_index];
        return (temp.name, temp.isCompiled);
    }
}
