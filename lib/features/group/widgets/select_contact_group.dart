import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/widgets/error.dart';

import '../../../common/widget/loader.dart';
import '../../screen_contact/controller/select_contact_controller.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectedContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactProvider).when(
          data: (contactList) => Expanded(
            child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () => selectedContact(index, contact),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: selectedContactsIndex.contains(index)
                          ? IconButton(
                              onPressed: () {}, icon: const Icon(Icons.done))
                          : null,
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          error: (err, trace) => ErrorScreeen(
            error: err.toString(),
          ),
          loading: () => Loader(),
        );
  }
}
