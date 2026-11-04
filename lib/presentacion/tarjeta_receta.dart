import 'package:flutter/material.dart';
import '../dominio/receta.dart';

class TarjetaReceta extends StatelessWidget {
  const TarjetaReceta({super.key, required this.receta});

  final Receta receta;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    receta.nombre,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (receta.esRapida)
                  const Chip(
                    label: Text('Rápida'),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text('${receta.cocina} · ${receta.dificultad.etiqueta}'),
            const SizedBox(height: 8),
            // Línea unificada de tiempo y porciones con punto medio '·'
            Text('Tiempo: ${receta.tiempoTotal} min · Porciones: ${receta.porciones}'),
            const SizedBox(height: 4),
            Text('Calificación: ${receta.calificacion.toStringAsFixed(1)}'),
          ],
        ),
      ),
    );
  }
}