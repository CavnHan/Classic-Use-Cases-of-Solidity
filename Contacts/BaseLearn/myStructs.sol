// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract Todos{
    //结构体，用于多种数据类型整合在一起
    struct Todo{
        string text;
        bool completed;
    }
    //定义一个Todo类型的数组
    Todo[] public todos;

    function create(string calldata _text) public {
        todos.push(Todo(_text,false));//使用构造函数创建

        todos.push(Todo({text: _text, completed: false}));//使用命名参数写法,适用于参数较多或明确指定

        //初始化一个空结构，然后更新
        Todo memory todo;
        todo.text = _text;
        //todo.completed默认值为false
        todos.push(todo);
    }
    //自动会为Todo创建这个get函数
    function get(uint256 _index) public view  returns (string memory text, bool completed){
        Todo storage todo = todos[_index];
        return (todo.text,Todo.completed);
    }
     // update text
    function updateText(uint256 _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }
    //updte completed
    function toggleCompleted(uint256 _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed;
    }
}