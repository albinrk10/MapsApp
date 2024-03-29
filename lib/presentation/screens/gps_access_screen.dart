import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas_app/presentation/blocs/gps/gps_bloc.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        Center(child: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
     
      return !state.isGpsEnabled
          ? const _EnableGpsMessage()
          : const _AccessButton();
    })));
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario el acceso a Gps'),
        MaterialButton(
          color: Colors.black,
          splashColor: Colors.transparent,
          shape: const StadiumBorder(),
          elevation: 0,
          onPressed: () {

            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();

          },
          child: const Text(
            'Permitir acceso',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage();

  @override
  Widget build(BuildContext context) {
    return const Text('Debe de habilitar el Gps',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300));
  }
}
