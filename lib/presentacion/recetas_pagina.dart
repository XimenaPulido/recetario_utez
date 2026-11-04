import 'package:flutter/material.dart';
import '../dominio/receta.dart';
import 'recetas_view_model.dart';
import 'tarjeta_receta.dart';

class RecetasPagina extends StatefulWidget {
  const RecetasPagina({super.key, required this.vm});

  final RecetasViewModel vm;

  @override
  State<RecetasPagina> createState() => _RecetasPaginaState();
}

class _RecetasPaginaState extends State<RecetasPagina> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _ejecutarBusqueda() {
    widget.vm.buscar(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetario UTEZ'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('busqueda'),
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _ejecutarBusqueda(),
                    decoration: const InputDecoration(
                      hintText: 'Buscar receta...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ListenableBuilder(
                  listenable: widget.vm,
                  builder: (context, _) {
                    return FilledButton(
                      key: const Key('buscar'),
                      onPressed: widget.vm.cargando ? null : _ejecutarBusqueda,
                      child: const Text('Buscar recetas'),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.vm,
              builder: (context, _) {
                final estado = widget.vm.estado;
                return switch (estado) {
                  RecetasInicial() => const Center(
                    child: Text(
                      'Escribe una receta o déjalo vacío y toca Buscar recetas.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RecetasCargando() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  RecetasVacias(:final busqueda) => Center(
                    child: Text(
                      busqueda.isEmpty
                          ? 'No hay recetas disponibles.'
                          : 'No encontramos recetas para "$busqueda".',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RecetasFallidas(:final mensaje) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(mensaje, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => widget.vm.reintentar(),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                  RecetasListas(:final recetas, :final total) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          // Formato exacto requerido con punto medio '·'
                          'Mostrando ${recetas.length} de $total recetas · Rápidas: ${widget.vm.rapidas}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: recetas.length,
                          itemBuilder: (context, index) {
                            return TarjetaReceta(receta: recetas[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}