// ignore: duplicate_ignore
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:voter_app/pages/electionInfo.dart';
import 'package:web3dart/web3dart.dart';

import '../services/functions.dart';
import '../utils/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Election"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              filled: true,
              hintText: "enter election name"
            ),
          ),

          SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async{
                  if (controller.text.isNotEmpty) {
                   await startElection(controller.text, ethClient!);
                   // ignore: use_build_context_synchronously
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ElectionInfo(ethClient: ethClient!, electionName: controller.text,),
                    ),
                  );
                  } 
                },
     
                child: const Text("start election")
              ),
            ),
        ],
      ),
    );
  }
}
