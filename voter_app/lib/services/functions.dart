// ignore: depend_on_referenced_packages
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';

import '../utils/constants.dart';

Future<DeployedContract> loadContract() async {
  String abiCode = await rootBundle.loadString("assets/abi.json");
  String contractAddress = contactAddress1;

  final contract = DeployedContract(ContractAbi.fromJson(abiCode, "Election"),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(String functionName, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract, 
          function: ethFunction, 
          parameters: args,
          ),
          chainId: null,
          fetchChainIdFromNetworkId: true,
          );
  return result;
}

Future<String> startElection(String name, Web3Client ethClient) async {
  var response =
      await callFunction('startElection', [name], ethClient, owner_private_key);
  // ignore: avoid_print
  print('Election started successfully');
  return response;
}

Future<String> addCandidate(String name, Web3Client ethClient) async {
  var response =
      await callFunction('addCandidate', [name], ethClient, owner_private_key);
  // ignore: avoid_print
  print('Candidate added successfully');
  return response;
}

Future<String> authorizeVoter(String address, Web3Client ethClient) async {
  var response = await callFunction('authorizeVoter',
      [EthereumAddress.fromHex(address)], ethClient, owner_private_key);
  // ignore: avoid_print
  print('Voter authorized');
  return response;
}

Future<List> getCandidateNum(Web3Client ethClient) async {
  List<dynamic> result = await ask('getNumCandidates', [], ethClient);
  return result;
}

Future<List<dynamic>> ask(String functionName, List<dynamic> args,Web3Client ethClient) async {
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<String> vote(int candidateIndex, Web3Client ethClient) async {
  var response = await callFunction('vote', [BigInt.from(candidateIndex)], ethClient, voter_private_key);
  // ignore: avoid_print
  print('Voted counted successfully');
  return response;
}