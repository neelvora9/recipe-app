import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

/// A highly customizable debouncer class with advanced features
class Debouncer {
  Timer? _timer;
  Duration _duration;
  VoidCallback? _callback;

  // Configuration options
  bool _autoCancel;
  bool _enableLogging;
  String _debugName;
  int _maxExecutions;
  int _currentExecutions;
  bool _isPaused;
  DateTime? _lastExecuted;
  Duration? _cooldownDuration;

  // Callbacks for different events
  VoidCallback? _onStart;
  VoidCallback? _onCancel;
  VoidCallback? _onExecute;
  VoidCallback? _onMaxExecutionsReached;
  VoidCallback? _onCooldownActive;
  Function(String)? _onLog;

  // Statistics
  int _totalCalls = 0;
  int _totalExecutions = 0;
  int _totalCancellations = 0;

  /// Creates a new Debouncer with customizable options
  Debouncer({
    required Duration duration,
    bool autoCancel = true,
    bool enableLogging = false,
    String debugName = 'Debouncer',
    int maxExecutions = -1, // -1 means unlimited
    Duration? cooldownDuration,
    VoidCallback? onStart,
    VoidCallback? onCancel,
    VoidCallback? onExecute,
    VoidCallback? onMaxExecutionsReached,
    VoidCallback? onCooldownActive,
    Function(String)? onLog,
  })  : _duration = duration,
        _autoCancel = autoCancel,
        _enableLogging = enableLogging,
        _debugName = debugName,
        _maxExecutions = maxExecutions,
        _currentExecutions = 0,
        _isPaused = false,
        _cooldownDuration = cooldownDuration,
        _onStart = onStart,
        _onCancel = onCancel,
        _onExecute = onExecute,
        _onMaxExecutionsReached = onMaxExecutionsReached,
        _onCooldownActive = onCooldownActive,
        _onLog = onLog;

  /// Execute the debounced function
  void call(VoidCallback callback) {
    _totalCalls++;
    _log('Call #$_totalCalls received');

    if (_isPaused) {
      _log('Debouncer is paused, ignoring call');
      return;
    }

    // Check max executions limit
    if (_maxExecutions > 0 && _currentExecutions >= _maxExecutions) {
      _log('Max executions ($_maxExecutions) reached');
      _onMaxExecutionsReached?.call();
      return;
    }

    // Check cooldown period
    if (_isInCooldown()) {
      _log('In cooldown period, ignoring call');
      _onCooldownActive?.call();
      return;
    }

    _callback = callback;

    // Cancel existing timer if auto-cancel is enabled
    if (_autoCancel && _timer?.isActive == true) {
      _cancel();
    }

    // Start new timer
    _startTimer();
  }

  /// Start the internal timer
  void _startTimer() {
    _log('Starting timer with duration: ${_duration.inMilliseconds}ms');
    _onStart?.call();

    _timer = Timer(_duration, () {
      _execute();
    });
  }

  /// Execute the callback
  void _execute() {
    if (_callback != null && !_isPaused) {
      _log('Executing callback');
      _currentExecutions++;
      _totalExecutions++;
      _lastExecuted = DateTime.now();
      _onExecute?.call();
      _callback!();
      _callback = null;
    }
  }

  /// Cancel the current timer
  void _cancel() {
    if (_timer?.isActive == true) {
      _log('Cancelling timer');
      _totalCancellations++;
      _timer!.cancel();
      _onCancel?.call();
    }
  }

  /// Check if currently in cooldown period
  bool _isInCooldown() {
    if (_cooldownDuration == null || _lastExecuted == null) return false;

    final timeSinceLastExecution = DateTime.now().difference(_lastExecuted!);
    return timeSinceLastExecution < _cooldownDuration!;
  }

  /// Log a message if logging is enabled
  void _log(String message) {
    if (_enableLogging) {
      final logMessage = '[$_debugName] $message';
      if (_onLog != null) {
        _onLog!(logMessage);
      } else {
        print(logMessage);
      }
    }
  }

  // Public control methods

  /// Cancel the current debounce operation
  void cancel() {
    _cancel();
    _callback = null;
  }

  /// Pause the debouncer (will ignore all calls)
  void pause() {
    _log('Pausing debouncer');
    _isPaused = true;
    cancel();
  }

  /// Resume the debouncer
  void resume() {
    _log('Resuming debouncer');
    _isPaused = false;
  }

  /// Reset execution counter and statistics
  void reset() {
    _log('Resetting debouncer');
    cancel();
    _currentExecutions = 0;
    _totalCalls = 0;
    _totalExecutions = 0;
    _totalCancellations = 0;
    _lastExecuted = null;
  }

  /// Force execute the current callback immediately
  void flush() {
    if (_callback != null) {
      _log('Force executing callback');
      cancel();
      _execute();
    }
  }

  /// Dispose and cleanup resources
  void dispose() {
    _log('Disposing debouncer');
    cancel();
    _callback = null;
  }

  // Configuration methods

  /// Update the debounce duration
  void setDuration(Duration duration) {
    _log('Setting duration to: ${duration.inMilliseconds}ms');
    _duration = duration;
  }

  /// Update the cooldown duration
  void setCooldownDuration(Duration? duration) {
    _log('Setting cooldown duration to: ${duration?.inMilliseconds}ms');
    _cooldownDuration = duration;
  }

  /// Update max executions limit
  void setMaxExecutions(int maxExecutions) {
    _log('Setting max executions to: $maxExecutions');
    _maxExecutions = maxExecutions;
  }

  /// Enable or disable auto-cancel
  void setAutoCancel(bool autoCancel) {
    _log('Setting auto-cancel to: $autoCancel');
    _autoCancel = autoCancel;
  }

  /// Enable or disable logging
  void setLogging(bool enable) {
    _enableLogging = enable;
    _log('Logging ${enable ? 'enabled' : 'disabled'}');
  }

  // Getters for status and statistics

  /// Check if debouncer is currently active (has pending execution)
  bool get isActive => _timer?.isActive == true;

  /// Check if debouncer is paused
  bool get isPaused => _isPaused;

  /// Get current duration
  Duration get duration => _duration;

  /// Get current execution count
  int get executionCount => _currentExecutions;

  /// Get total calls made
  int get totalCalls => _totalCalls;

  /// Get total executions completed
  int get totalExecutions => _totalExecutions;

  /// Get total cancellations
  int get totalCancellations => _totalCancellations;

  /// Get time until next execution (if active)
  Duration? get timeUntilExecution {
    if (!isActive) return null;
    // This is an approximation since Timer doesn't expose remaining time
    return _duration;
  }

  /// Get time since last execution
  Duration? get timeSinceLastExecution {
    if (_lastExecuted == null) return null;
    return DateTime.now().difference(_lastExecuted!);
  }

  /// Get remaining cooldown time
  Duration? get remainingCooldownTime {
    if (!_isInCooldown()) return null;
    final elapsed = DateTime.now().difference(_lastExecuted!);
    return _cooldownDuration! - elapsed;
  }

  /// Get debouncer statistics as a map
  Map<String, dynamic> get statistics => {
        'debugName': _debugName,
        'isActive': isActive,
        'isPaused': isPaused,
        'duration': _duration.toString(),
        'currentExecutions': _currentExecutions,
        'maxExecutions': _maxExecutions,
        'totalCalls': _totalCalls,
        'totalExecutions': _totalExecutions,
        'totalCancellations': _totalCancellations,
        'lastExecuted': _lastExecuted?.toIso8601String(),
        'timeSinceLastExecution': timeSinceLastExecution?.toString(),
        'cooldownDuration': _cooldownDuration?.toString(),
        'remainingCooldownTime': remainingCooldownTime?.toString(),
        'isInCooldown': _isInCooldown(),
      };
}

class DebouncerExamples extends StatefulWidget {
  @override
  _DebouncerExamplesState createState() => _DebouncerExamplesState();
}

class _DebouncerExamplesState extends State<DebouncerExamples> {
  late Debouncer searchDebouncer;
  late Debouncer buttonDebouncer;
  late Debouncer advancedDebouncer;

  String searchResults = '';
  String buttonPressCount = '0';
  String advancedStatus = '';

  @override
  void initState() {
    super.initState();

    // Example 1: Simple search debouncer
    searchDebouncer = Debouncer(
      duration: Duration(milliseconds: 500),
      debugName: 'SearchDebouncer',
      enableLogging: true,
    );

    // Example 2: Button press debouncer with max executions
    buttonDebouncer = Debouncer(
      duration: Duration(milliseconds: 1000),
      maxExecutions: 5,
      debugName: 'ButtonDebouncer',
      enableLogging: true,
      onMaxExecutionsReached: () {
        setState(() {
          buttonPressCount = 'Max reached!';
        });
      },
    );

    // Example 3: Advanced debouncer with all features
    advancedDebouncer = Debouncer(
      duration: Duration(milliseconds: 800),
      cooldownDuration: Duration(seconds: 2),
      maxExecutions: 3,
      debugName: 'AdvancedDebouncer',
      enableLogging: true,
      onStart: () => _updateAdvancedStatus('Timer started'),
      onCancel: () => _updateAdvancedStatus('Timer cancelled'),
      onExecute: () => _updateAdvancedStatus('Executed!'),
      onCooldownActive: () => _updateAdvancedStatus('In cooldown'),
      onMaxExecutionsReached: () => _updateAdvancedStatus('Max executions reached'),
    );
  }

  void _updateAdvancedStatus(String status) {
    setState(() {
      advancedStatus = status;
    });
  }

  void _performSearch(String query) {
    searchDebouncer(() {
      setState(() {
        searchResults = 'Searching for: "$query"...';
      });

      // Simulate API call
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            searchResults = 'Results for "$query": Found ${query.length} items';
          });
        }
      });
    });
  }

  void _handleButtonPress() {
    buttonDebouncer(() {
      setState(() {
        int current = int.tryParse(buttonPressCount) ?? 0;
        buttonPressCount = (current + 1).toString();
      });
    });
  }

  void _handleAdvancedAction() {
    advancedDebouncer(() {
      _updateAdvancedStatus('Action executed at ${DateTime.now().toString().substring(11, 19)}');
    });
  }

  @override
  void dispose() {
    searchDebouncer.dispose();
    buttonDebouncer.dispose();
    advancedDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debouncer Examples'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Search Debouncer
            Text('1. Search Debouncer (500ms)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Type to search...',
                border: OutlineInputBorder(),
              ),
              onChanged: _performSearch,
            ),
            SizedBox(height: 8),
            Text('Results: $searchResults'),

            SizedBox(height: 32),

            // Example 2: Button Debouncer
            Text('2. Button Debouncer (1s, max 5)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _handleButtonPress,
                  child: Text('Press Me'),
                ),
                SizedBox(width: 16),
                Text('Count: $buttonPressCount'),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    buttonDebouncer.reset();
                    setState(() {
                      buttonPressCount = '0';
                    });
                  },
                  child: Text('Reset'),
                ),
              ],
            ),

            SizedBox(height: 32),

            // Example 3: Advanced Debouncer
            Text('3. Advanced Debouncer (800ms, 2s cooldown, max 3)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _handleAdvancedAction,
                  child: Text('Advanced Action'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    advancedDebouncer.pause();
                    _updateAdvancedStatus('Paused');
                  },
                  child: Text('Pause'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    advancedDebouncer.resume();
                    _updateAdvancedStatus('Resumed');
                  },
                  child: Text('Resume'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Status: $advancedStatus'),

            SizedBox(height: 16),

            // Control buttons for advanced debouncer
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    advancedDebouncer.flush();
                  },
                  child: Text('Flush'),
                ),
                ElevatedButton(
                  onPressed: () {
                    advancedDebouncer.cancel();
                    _updateAdvancedStatus('Cancelled');
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    advancedDebouncer.reset();
                    _updateAdvancedStatus('Reset');
                  },
                  child: Text('Reset'),
                ),
              ],
            ),

            SizedBox(height: 32),

            // Statistics Display
            Text('Statistics:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Advanced Debouncer Stats:'),
                  Text('Active: ${advancedDebouncer.isActive}'),
                  Text('Paused: ${advancedDebouncer.isPaused}'),
                  Text('Executions: ${advancedDebouncer.executionCount}/3'),
                  Text('Total Calls: ${advancedDebouncer.totalCalls}'),
                  Text('Total Executions: ${advancedDebouncer.totalExecutions}'),
                  Text('Cancellations: ${advancedDebouncer.totalCancellations}'),
                  if (advancedDebouncer.timeSinceLastExecution != null) Text('Time Since Last: ${advancedDebouncer.timeSinceLastExecution}'),
                  if (advancedDebouncer.remainingCooldownTime != null) Text('Cooldown Remaining: ${advancedDebouncer.remainingCooldownTime}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example of a custom debounced text widget
class DebouncedTextField extends StatefulWidget {
  final Function(String) onChanged;
  final Duration debounceDuration;
  final String? hintText;

  const DebouncedTextField({
    Key? key,
    required this.onChanged,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.hintText,
  }) : super(key: key);

  @override
  _DebouncedTextFieldState createState() => _DebouncedTextFieldState();
}

class _DebouncedTextFieldState extends State<DebouncedTextField> {
  late Debouncer _debouncer;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _debouncer = Debouncer(
      duration: widget.debounceDuration,
      debugName: 'DebouncedTextField',
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        _debouncer(() {
          widget.onChanged(value);
        });
      },
    );
  }
}
