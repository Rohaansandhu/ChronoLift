import 'package:flutter/material.dart';

class InlineEditableField extends StatefulWidget {
  final int exerciseIndex;
  final int setIndex;
  final String fieldType; // weight, reps, notes
  final String value;
  final String label;
  final Function(String) onChanged;
  final bool isEditing;
  final VoidCallback? onStartEditing;
  final VoidCallback? onStopEditing;

  const InlineEditableField({
    super.key,
    required this.exerciseIndex,
    required this.setIndex,
    required this.fieldType,
    required this.value,
    required this.label,
    required this.onChanged,
    this.isEditing = false,
    this.onStartEditing,
    this.onStopEditing,
  });

  @override
  State<InlineEditableField> createState() => _InlineEditableFieldState();
}

class _InlineEditableFieldState extends State<InlineEditableField> {
  late TextEditingController _controller;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditing;
    _initializeController();
  }

  @override
  void didUpdateWidget(InlineEditableField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEditing != widget.isEditing) {
      _isEditing = widget.isEditing;
      if (_isEditing) {
        _initializeController();
      }
    }
  }

  void _initializeController() {
    final bool showDefaultValue = 
        widget.value == "0" || widget.value == "0.0" || widget.value == "";
    _controller = TextEditingController(
      text: showDefaultValue ? "" : widget.value,
    );
  }

  void _handleSubmit(String newValue) {
    widget.onChanged(newValue);
    _stopEditing();
  }

  void _handleTapOutside() {
    widget.onChanged(_controller.text);
    _stopEditing();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    _initializeController();
    widget.onStartEditing?.call();
  }

  void _stopEditing() {
    setState(() {
      _isEditing = false;
    });
    widget.onStopEditing?.call();
    _controller.dispose();
  }

  @override
  void dispose() {
    if (_isEditing) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        onSubmitted: _handleSubmit,
        onTapOutside: (_) => _handleTapOutside(),
      );
    }

    return InkWell(
      onTap: _startEditing,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          (widget.value == "0" || widget.value == "0.0") 
              ? widget.label 
              : '${widget.label} ${widget.value}',
          style: TextStyle(
            color: widget.value == "0"
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                : null,
          ),
        ),
      ),
    );
  }
}