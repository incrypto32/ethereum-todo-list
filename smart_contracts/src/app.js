// Show an element
var show = function (elem) {
	elem.style.display = 'block';
};

// Hide an element
var hide = function (elem) {
	elem.style.display = 'none';
};

App = {
  loading: false,
  contracts: {},
  load: async () => {
    await App.loadWeb3();
    await App.loadContract();
    await App.render();
  },

  loadWeb3: async () => {
    if (window.ethereum) {
      const accounts = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      App.account = accounts[0];
      App.web3Provider = window.ethereum;
      window.web3 = new Web3(window.ethereum);
    }
  },

  getAbi: async (fileName) => {
    var requestOptions = {
      method: "GET",
      redirect: "follow",
    };

    var json = await fetch(fileName, requestOptions).then((response) =>
      response.json()
    );
    return json;
  },

  loadContract: async () => {
    const todoList = await App.getAbi("TodoList.json");
    App.contracts.TodoList = TruffleContract(todoList);
    App.contracts.TodoList.setProvider(App.web3Provider);
    App.todoList = await App.contracts.TodoList.deployed();
  },

  render: async () => {
    // Prevent double render
    if (App.loading) {
      return;
    }

    // Update app loading state
    App.setLoading(true);

    // Render Tasks
    await App.renderTasks();

    // Update loading state
    App.setLoading(false);
  },

  renderTasks: async () => {
    const taskCount = await App.todoList.taskCount();
    const taskTemplate = document.querySelector("#taskList");

    for (let i = 0; i < taskCount; i++) {
      let task = await App.todoList.tasks(i + 1);

      const taskElement = document.createElement("div");
      taskElement.classList.add(".taskTemplate", ".checkbox");
      taskElement.innerHTML = `
      <label>
      <input type="checkbox" />
      <span class="content">${task.content}</span>
      </label>`;

      taskTemplate.appendChild(taskElement);
    }
  },

  setLoading: (boolean) => {
    App.loading = boolean;
    const loader = document.getElementById("loader");
    const content = document.getElementById("content");
    if (boolean) {
      show(loader)
      hide(content);
    } else {
     hide(loader);
     show(content);
    }
  },
};
window.onload = () => App.load();
