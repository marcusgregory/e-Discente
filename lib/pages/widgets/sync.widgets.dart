import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SynchronizingWidget extends StatelessWidget {
  const SynchronizingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sincronizando...',
          style: GoogleFonts.darkerGrotesque(
              fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          width: 10,
        ),
        const SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 3.0,
            ))
      ],
    );
  }
}

class SyncErrorWidget extends StatelessWidget {
  const SyncErrorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Sincronização falhou (offline)',
        style: GoogleFonts.darkerGrotesque(
            fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
