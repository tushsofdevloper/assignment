import 'package:flutter/material.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Dock(
            items: [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
          ),
        ),
      ),
    );
  }
}

class Dock extends StatefulWidget {
  const Dock({super.key, required this.items});

  final List<IconData> items;

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  late List<IconData> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.items.toList();
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex != newIndex) {
      setState(() {
        final item = _items.removeAt(oldIndex);
        _items.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 150, 70, 70).withOpacity(0.7),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (index) {
          return _buildDraggableIcon(index);
        }),
      ),
    );
  }

  Widget _buildDraggableIcon(int index) {
    return Draggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: _buildIcon(_items[index], isDragging: true),
      ),
      childWhenDragging: const SizedBox.shrink(),
      onDragCompleted: () {},
      onDraggableCanceled: (_, __) {
        setState(() {});
      },
      child: DragTarget<int>(
        builder: (context, candidateData, rejectedData) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _buildIcon(_items[index]),
          );
        },
        onWillAccept: (draggedIndex) {
          if (draggedIndex != index) {
            _onReorder(draggedIndex!, index);
          }
          return true;
        },
      ),
    );
  }

  Widget _buildIcon(IconData icon, {bool isDragging = false}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 48),
      height: 48,
      margin: const EdgeInsets.all(8),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          size: isDragging ? 40 : 32,
        ),
      ),
    );
  }
}
