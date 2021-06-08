// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12

import 'package:web3dart/web3dart.dart' as _i1;

class TodoList extends _i1.GeneratedContract {
  TodoList(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(
            _i1.DeployedContract(
                _i1.ContractAbi.fromJson(
                    '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"id","type":"uint256"},{"indexed":false,"internalType":"bool","name":"completed","type":"bool"}],"name":"TaskCompleted","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"id","type":"uint256"},{"indexed":false,"internalType":"string","name":"content","type":"string"},{"indexed":false,"internalType":"bool","name":"completed","type":"bool"}],"name":"TaskCreated","type":"event"},{"inputs":[],"name":"taskCount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"tasks","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"content","type":"string"},{"internalType":"bool","name":"completed","type":"bool"}],"stateMutability":"view","type":"function","constant":true},{"inputs":[{"internalType":"string","name":"_content","type":"string"}],"name":"createTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_id","type":"uint256"}],"name":"toggleCompleted","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
                    'TodoList'),
                address),
            client,
            chainId);

  Future<BigInt> taskCount() async {
    final function = self.function('taskCount');
    final params = [];
    final response = await read(function, params);
    return (response[0] as BigInt);
  }

  Future<Tasks> tasks(BigInt i) async {
    final function = self.function('tasks');
    final params = [i];
    final response = await read(function, params);
    return Tasks(response);
  }

  Future<String> createTask(String _content,
      {required _i1.Credentials credentials}) async {
    final function = self.function('createTask');
    final params = [_content];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<String> toggleCompleted(BigInt _id,
      {required _i1.Credentials credentials}) async {
    final function = self.function('toggleCompleted');
    final params = [_id];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  /// Returns a live stream of all TaskCompleted events emitted by this contract.
  Stream<TaskCompleted> taskCompletedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('TaskCompleted');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return TaskCompleted(decoded);
    });
  }

  /// Returns a live stream of all TaskCreated events emitted by this contract.
  Stream<TaskCreated> taskCreatedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('TaskCreated');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return TaskCreated(decoded);
    });
  }
}

class Tasks {
  Tasks(List<dynamic> response)
      : id = (response[0] as BigInt),
        content = (response[1] as String),
        completed = (response[2] as bool);

  final BigInt id;

  final String content;

  final bool completed;
}

class TaskCompleted {
  TaskCompleted(List<dynamic> response)
      : id = (response[0] as BigInt),
        completed = (response[1] as bool);

  final BigInt id;

  final bool completed;
}

class TaskCreated {
  TaskCreated(List<dynamic> response)
      : id = (response[0] as BigInt),
        content = (response[1] as String),
        completed = (response[2] as bool);

  final BigInt id;

  final String content;

  final bool completed;
}
