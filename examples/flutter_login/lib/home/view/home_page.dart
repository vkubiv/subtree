import 'package:flutter/material.dart';
import 'package:flutter_login/home/models.dart';
import 'package:subtree/state.dart';
import 'package:subtree/subtree.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.getState<HomeState>();
    final actions = context.getActions<HomeActions>();

    return Scaffold(
        appBar: AppBar(title: const Text('Home'), actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: actions.logout,
          ),
        ]),
        body: Center(
          child: EventListener<String>(
            event: state.errorEvent,
            listener: (context, errorMessage) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
            },
            child: Obx(
              (ref) {
                final user = ref.watch(state.userProfile);
                if (user == null) {
                  return CircularProgressIndicator();
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("First name ${user.firstName}"),
                    Text("Last name ${user.lastName}"),
                    ElevatedButton(child: const Text('Logout'), onPressed: actions.logout)
                  ],
                );
              },
            ),
          ),
        ));
  }
}
