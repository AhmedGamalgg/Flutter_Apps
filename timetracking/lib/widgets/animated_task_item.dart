import 'package:flutter/material.dart';
import '../models/task.dart';

class AnimatedTaskItem extends StatefulWidget {
  final Task task;
  final Function(Task) onToggle;
  final Function(Task) onDelete;

  const AnimatedTaskItem({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<AnimatedTaskItem> createState() => _AnimatedTaskItemState();
}

class _AnimatedTaskItemState extends State<AnimatedTaskItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDismiss() async {
    await _controller.reverse();
    widget.onDelete(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Dismissible(
          key: Key(widget.task.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delete Task'),
                      content: const Text(
                        'Are you sure you want to delete this task?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                ) ??
                false;
          },
          onDismissed: (_) => _handleDismiss(),
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: CheckboxListTile(
              title: Text(
                widget.task.title,
                style: TextStyle(
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: widget.task.description != null
                  ? Text(widget.task.description!)
                  : null,
              value: widget.task.isCompleted,
              onChanged: (_) => widget.onToggle(widget.task),
              secondary: widget.task.assignedDate != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.event),
                        Text(
                          '${widget.task.assignedDate!.day}/${widget.task.assignedDate!.month}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    )
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ),
      ),
    );
  }
}
