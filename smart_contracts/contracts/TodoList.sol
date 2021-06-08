// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract TodoList {
    uint256 public taskCount = 0;

    struct Task {
        uint256 id;
        string content;
        bool completed;
    }

    event TaskCreated(uint256 id, string content, bool completed);
    event TaskCompleted(uint256 id, bool completed);

    mapping(uint256 => Task) public tasks;

    constructor() {
        createTask("Buy Keyboard");
    }

    function createTask(string memory _content) public {
        taskCount++;
        tasks[taskCount] = Task(taskCount, _content, false);
        emit TaskCreated(taskCount, _content, false);
    }

    function toggleCompleted(uint256 _id) public {
       
        tasks[_id].completed = !tasks[_id].completed;
   
        emit TaskCompleted(_id, tasks[_id].completed);
    }
}
