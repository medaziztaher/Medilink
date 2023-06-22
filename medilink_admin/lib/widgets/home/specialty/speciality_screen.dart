import 'package:flutter/material.dart';

import '../../../models/speciality.dart';
import '../../../services/networkhandler.dart';
import '../../../services/path.dart';

class AddSpeciality extends StatefulWidget {
  const AddSpeciality({Key? key}) : super(key: key);

  @override
  State<AddSpeciality> createState() => _AddSpecialityState();
}

class _AddSpecialityState extends State<AddSpeciality> {
  bool isloading = false;
  bool iscircular = false;
  NetworkHandler networkHandler = NetworkHandler();
  List<Speciality> specialites = [];
  late String newSpeciality;

  Future<void> addSpeciality(String speciality) async {
    setState(() {
      isloading = true;
    });
    final data = {
      'speciality': speciality,
    };
    try {
      await networkHandler.post(specialitePath, data);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> deleteSpeciality(String id) async {
    setState(() {
      isloading = true;
    });
    try {
      await networkHandler.delete("$specialitePath/$id");
      await getAllSpeciality();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> getAllSpeciality() async {
    setState(() {
      iscircular = true;
    });
    try {
      final response = await networkHandler.get(specialitePath);
      print(response);
      final data = response['data'] as List<dynamic>;
      final newSpecialities =
          data.map((item) => Speciality.fromJson(item)).toList(growable: false);
      print(newSpecialities);
      setState(() {
        specialites = newSpecialities;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        iscircular = false;
      });
    }
  }

  Future<void> updateSpeciality(String id, String speciality) async {
    setState(() {
      isloading = true;
    });
    final data = {
      'speciality': speciality,
    };
    try {
      await networkHandler.put("$specialitePath/$id", data);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllSpeciality();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Specialities'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                Text("Add Speciality"),
                TextField(
                  onChanged: (value) {
                    newSpeciality = value;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    await addSpeciality(newSpeciality);
                    await getAllSpeciality();
                  },
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("Speciality List"),
            Expanded(
              child: iscircular
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: specialites.length,
                      itemBuilder: (BuildContext context, int index) {
                        Speciality speciality = specialites[index];
                        print(speciality);
                        return ListTile(
                          title: Text(speciality.nom ?? ""),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await deleteSpeciality(speciality.id!);
                              await getAllSpeciality();
                            },
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Change'),
                                  content: TextField(
                                    onChanged: (value) {
                                      newSpeciality = value;
                                    },
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await updateSpeciality(
                                          speciality.id!,
                                          newSpeciality,
                                        );
                                        await getAllSpeciality();
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
