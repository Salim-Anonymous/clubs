//scaffold to display the list of member requests
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubs/models/Request.dart';
import 'package:flutter/material.dart';

class MemberRequests extends StatefulWidget {
  final String cid;
  const MemberRequests({Key? key, required this.cid}) : super(key: key);

  @override
  State<MemberRequests> createState() => _MemberRequestsState();
}

class _MemberRequestsState extends State<MemberRequests> {
  List<Request> requests = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('clubs')
        .doc(widget.cid)
        .collection('requests')
        .get()
        .then((value) {
      setState(() {
        requests = value.docs
            .map((e) => Request.fromMap(e.id, e.data()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: const [
            Text(
              "Member Requests",
              style: TextStyle(color: Colors.black),
              softWrap: true,
            ),
            Icon(Icons.arrow_forward, color: Colors.black)
          ],),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 5,
          leading: null,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          scrollDirection: Axis.vertical,
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.grey[200],
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      requests[index].email,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('clubs')
                                .doc(widget.cid)
                                .collection('requests')
                                .doc(requests[index].mid)
                                .delete();
                            FirebaseFirestore.instance
                                .collection('clubs')
                                .doc(widget.cid)
                                .update({
                              'members': FieldValue.arrayUnion(
                                  [requests[index].email])
                            });
                            FirebaseFirestore.instance
                              .collection('clubs')
                              .doc(widget.cid)
                               .collection('members')
                                .doc(requests[index].uid)
                                .set({
                              'email': requests[index].email,
                            }
                            );
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(requests[index].uid)
                                .collection('clubs')
                                .doc(widget.cid)
                                .set({});
                            setState(() {
                              requests.removeAt(index);
                            });
                          },
                          child: const Text('Accept'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('clubs')
                                .doc(widget.cid)
                                .collection('requests')
                                .doc(requests[index].mid)
                                .delete();
                            setState(() {
                              requests.removeAt(index);
                            });
                          },
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ));
    }
}