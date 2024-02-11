import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas_app/presentation/blocs/blocs.dart';
import 'package:mapas_app/presentation/views/views.dart';
import 'package:mapas_app/presentation/widgets/wigets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    //  locationBloc.getCurrentPosition
    locationBloc.starFollowingUser();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state.lastKnownLocation == null) return const Center(child: Text('Espere Porfavor..'));

        return SingleChildScrollView(
          child: Stack(
            children: [
              MapView(
                initialLocation: state.lastKnownLocation!,
                
              ),
              //TODO: Add botones..
            ],
          ),
        );
      },
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    floatingActionButton: 
     const Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BtnCurrentLocation()
      ],
    )
    );
  }
}
