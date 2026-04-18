import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

void main() {
  runApp(const TaskManagerApp());
}

// ─── Models ──────────────────────────────────────────────────────────────────

class Task {
  final String id;
  String title;
  String? description;
  DateTime? dateTime;
  bool isCompleted;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.dateTime,
    this.isCompleted = false,
    required this.createdAt,
  });
}

class Note {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  final Color color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.color,
  });
}

// ─── App State ───────────────────────────────────────────────────────────────

class AppState extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Review project proposal',
      description: 'Check the new client proposal for Q3',
      dateTime: DateTime.now().add(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Task(
      id: '2',
      title: 'Team standup meeting',
      dateTime: DateTime.now().add(const Duration(hours: 5)),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Task(
      id: '3',
      title: 'Submit expense report',
      description: 'Monthly expense report due today',
      dateTime: DateTime.now().subtract(const Duration(hours: 1)),
      isCompleted: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      id: '4',
      title: 'Prepare presentation slides',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Task(
      id: '5',
      title: 'Call with marketing team',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<Note> _notes = [
    Note(
      id: '1',
      title: 'Meeting Notes',
      content: 'Discussed Q3 roadmap, need to finalize design system tokens and review sprint backlog before next week.',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      color: const Color(0xFFFFF3CD),
    ),
    Note(
      id: '2',
      title: 'Book List',
      content: 'Atomic Habits, Deep Work, The Pragmatic Programmer, Clean Architecture.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      color: const Color(0xFFD1F2EB),
    ),
    Note(
      id: '3',
      title: 'App Ideas',
      content: 'Habit tracker with streaks, Pomodoro timer with analytics, Focus music generator.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      color: const Color(0xFFD6EAF8),
    ),
    Note(
      id: '4',
      title: 'Grocery List',
      content: 'Milk, eggs, bread, butter, spinach, chicken, pasta, olive oil.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      color: const Color(0xFFFCE4EC),
    ),
    Note(
      id: '5',
      title: 'Workout Plan',
      content: 'Mon: Upper body. Wed: Lower body. Fri: Cardio + Core. Weekend: rest or yoga.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      color: const Color(0xFFEDE7F6),
    ),
  ];

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Note> get notes => List.unmodifiable(_notes);

  List<Task> get todayTasks {
    final now = DateTime.now();
    return _tasks.where((t) {
      if (t.dateTime == null) return false;
      return t.dateTime!.year == now.year &&
          t.dateTime!.month == now.month &&
          t.dateTime!.day == now.day;
    }).toList()
      ..sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
  }

  List<Task> get upcomingTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _tasks.where((t) {
      if (t.dateTime == null) return false;
      final taskDay = DateTime(t.dateTime!.year, t.dateTime!.month, t.dateTime!.day);
      return taskDay.isAfter(today);
    }).toList()
      ..sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
  }

  void addTask(Task task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void toggleTask(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _tasks[idx].isCompleted = !_tasks[idx].isCompleted;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void addNote(Note note) {
    _notes.insert(0, note);
    notifyListeners();
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}

// ─── Theme ───────────────────────────────────────────────────────────────────

class AppTheme {
  static const Color bg = Color(0xFF0F0F14);
  static const Color surface = Color(0xFF1A1A24);
  static const Color surfaceHigh = Color(0xFF22222F);
  static const Color accent = Color(0xFF7C6EF0);
  static const Color accentSoft = Color(0xFF9D93F5);
  static const Color accentGlow = Color(0x337C6EF0);
  static const Color textPrimary = Color(0xFFF0EFF8);
  static const Color textSecondary = Color(0xFF8B8AA0);
  static const Color textMuted = Color(0xFF4A4A5E);
  static const Color success = Color(0xFF52D9A0);
  static const Color warning = Color(0xFFFFB74D);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color border = Color(0xFF2A2A3A);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        fontFamily: 'SF Pro Display',
        colorScheme: const ColorScheme.dark(
          primary: accent,
          surface: surface,
          onSurface: textPrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          iconTheme: IconThemeData(color: textPrimary),
        ),
      );
}

// ─── Main App ─────────────────────────────────────────────────────────────────

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) => MaterialApp(
        title: 'Nucleus',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const HomeShell(),
      ),
    );
  }
}

final _appState = AppState();

// ─── Home Shell ───────────────────────────────────────────────────────────────

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _navController;

  final _pages = const [TasksPage(), SchedulePage(), NotesPage()];
  final _labels = ['Tasks', 'Schedule', 'Notes'];
  final _icons = [Icons.check_circle_outline_rounded, Icons.calendar_today_rounded, Icons.sticky_note_2_outlined];
  final _activeIcons = [Icons.check_circle_rounded, Icons.calendar_today_rounded, Icons.sticky_note_2_rounded];

  @override
  void initState() {
    super.initState();
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: const Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (i) => _NavItem(
              icon: _icons[i],
              activeIcon: _activeIcons[i],
              label: _labels[i],
              isActive: _currentIndex == i,
              onTap: () => setState(() => _currentIndex = i),
            )),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.accentGlow : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? AppTheme.accentSoft : AppTheme.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isActive ? AppTheme.accentSoft : AppTheme.textMuted,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.3,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tasks Page ──────────────────────────────────────────────────────────────

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        final tasks = _appState.tasks;
        final pending = tasks.where((t) => !t.isCompleted).length;

        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                pinned: true,
                backgroundColor: AppTheme.bg,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  title: Row(
                    children: [
                      const Text('Tasks', style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5,
                      )),
                      const SizedBox(width: 10),
                      if (pending > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('$pending', style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white,
                          )),
                        ),
                    ],
                  ),
                ),
              ),
              if (tasks.isEmpty)
                const SliverFillRemaining(child: _EmptyState(
                  icon: Icons.check_circle_outline_rounded,
                  message: 'No tasks yet',
                  sub: 'Tap + to add your first task',
                ))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _TaskCard(task: tasks[i]),
                      childCount: tasks.length,
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: _GlowFAB(
            onTap: () => _showAddTaskSheet(context),
          ),
        );
      },
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddTaskSheet(),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _appState.deleteTask(task.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: AppTheme.danger.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          // ignore: deprecated_member_use
          border: Border.all(color: AppTheme.danger.withOpacity(0.3)),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: AppTheme.danger),
      ),
      child: GestureDetector(
        onTap: () => _appState.toggleTask(task.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: task.isCompleted
                // ignore: deprecated_member_use
                ? AppTheme.surface.withOpacity(0.5)
                : AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: task.isCompleted
                  ? AppTheme.border
                  : AppTheme.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted ? AppTheme.success : Colors.transparent,
                  border: Border.all(
                    color: task.isCompleted ? AppTheme.success : AppTheme.textMuted,
                    width: 2,
                  ),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        color: task.isCompleted
                            ? AppTheme.textMuted
                            : AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: AppTheme.textMuted,
                      ),
                      child: Text(task.title),
                    ),
                    if (task.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (task.dateTime != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 12, color: AppTheme.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateTime(task.dateTime!),
                            style: TextStyle(
                              fontSize: 11,
                              color: _isOverdue(task)
                                  ? AppTheme.danger
                                  : AppTheme.textMuted,
                              fontWeight: _isOverdue(task)
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (_isOverdue(task) && !task.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: AppTheme.danger.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Late',
                      style: TextStyle(fontSize: 10, color: AppTheme.danger, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isOverdue(Task task) {
    if (task.isCompleted || task.dateTime == null) return false;
    return task.dateTime!.isBefore(DateTime.now());
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDay = DateTime(dt.year, dt.month, dt.day);
    final diff = taskDay.difference(today).inDays;

    String day;
    if (diff == 0) {
      day = 'Today';
    // ignore: curly_braces_in_flow_control_structures
    } else if (diff == 1) day = 'Tomorrow';
    // ignore: curly_braces_in_flow_control_structures
    else if (diff == -1) day = 'Yesterday';
    // ignore: curly_braces_in_flow_control_structures
    else day = '${dt.day}/${dt.month}';

    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$day at $h:$m';
  }
}

class _AddTaskSheet extends StatefulWidget {
  const _AddTaskSheet();

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('New Task', style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          )),
          const SizedBox(height: 16),
          _Field(controller: _titleCtrl, hint: 'Task title', autofocus: true),
          const SizedBox(height: 10),
          _Field(controller: _descCtrl, hint: 'Description (optional)'),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickDateTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 18, color: AppTheme.textMuted),
                  const SizedBox(width: 10),
                  Text(
                    _selectedDateTime == null
                        ? 'Pick date & time'
                        : _fmt(_selectedDateTime!),
                    style: TextStyle(
                      color: _selectedDateTime == null
                          ? AppTheme.textMuted
                          : AppTheme.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  if (_selectedDateTime != null)
                    GestureDetector(
                      onTap: () => setState(() => _selectedDateTime = null),
                      child: const Icon(Icons.close_rounded,
                          size: 16, color: AppTheme.textMuted),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text('Add Task', style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700,
              )),
            ),
          ),
        ],
      ),
    );
  }

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.accent,
            surface: AppTheme.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (date == null) return;

    final time = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.accent,
            surface: AppTheme.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submit() {
    if (_titleCtrl.text.trim().isEmpty) return;
    _appState.addTask(Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      dateTime: _selectedDateTime,
      createdAt: DateTime.now(),
    ));
    Navigator.pop(context);
  }

  String _fmt(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month}/${dt.year} at $h:$m';
  }
}

// ─── Schedule Page ────────────────────────────────────────────────────────────

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.bg,
        body: NestedScrollView(
          headerSliverBuilder: (ctx, _) => [
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              backgroundColor: AppTheme.bg,
              flexibleSpace: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.fromLTRB(20, 0, 20, 56),
                title: Text('Schedule', style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5,
                )),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorPadding: const EdgeInsets.all(3),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppTheme.textMuted,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    tabs: const [
                      Tab(text: 'Today'),
                      Tab(text: 'Upcoming'),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: ListenableBuilder(
            listenable: _appState,
            builder: (ctx, _) => TabBarView(
              children: [
                _ScheduleList(tasks: _appState.todayTasks, emptyMessage: "Nothing scheduled today"),
                _ScheduleList(tasks: _appState.upcomingTasks, emptyMessage: "No upcoming tasks"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final List<Task> tasks;
  final String emptyMessage;
  const _ScheduleList({required this.tasks, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _EmptyState(
        icon: Icons.event_available_rounded,
        message: emptyMessage,
        sub: 'Add tasks with a date to see them here',
      );
    }

    // Group by date for upcoming
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: tasks.length,
      itemBuilder: (ctx, i) => _ScheduleCard(task: tasks[i]),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final Task task;
  const _ScheduleCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final dt = task.dateTime!;
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final now = DateTime.now();
    final isNow = dt.isBefore(now.add(const Duration(hours: 1))) &&
        dt.isAfter(now.subtract(const Duration(minutes: 30)));

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 54,
            child: Column(
              children: [
                Text('$h:$m', style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isNow ? AppTheme.accent : AppTheme.textSecondary,
                )),
                const SizedBox(height: 6),
                Container(
                  width: 2,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        isNow ? AppTheme.accent : AppTheme.border,
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isNow
                    // ignore: deprecated_member_use
                    ? AppTheme.accent.withOpacity(0.1)
                    : AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  // ignore: deprecated_member_use
                  color: isNow ? AppTheme.accent.withOpacity(0.3) : AppTheme.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(task.title, style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: task.isCompleted
                              ? AppTheme.textMuted
                              : AppTheme.textPrimary,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        )),
                      ),
                      if (isNow)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Now', style: TextStyle(
                            fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700,
                          )),
                        ),
                      if (task.isCompleted)
                        const Icon(Icons.check_circle_rounded,
                            size: 16, color: AppTheme.success),
                    ],
                  ),
                  if (task.description != null) ...[
                    const SizedBox(height: 4),
                    Text(task.description!, style: const TextStyle(
                      fontSize: 12, color: AppTheme.textSecondary,
                    )),
                  ],
                  // Show day for upcoming
                  if (_dayLabel(dt) != null) ...[
                    const SizedBox(height: 6),
                    Text(_dayLabel(dt)!, style: const TextStyle(
                      fontSize: 11, color: AppTheme.textMuted,
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _dayLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDay = DateTime(dt.year, dt.month, dt.day);
    final diff = taskDay.difference(today).inDays;
    if (diff == 0) return null;
    if (diff == 1) return 'Tomorrow';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

// ─── Notes Page ───────────────────────────────────────────────────────────────

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  static const _noteColors = [
    Color(0xFFFFF3CD),
    Color(0xFFD1F2EB),
    Color(0xFFD6EAF8),
    Color(0xFFFCE4EC),
    Color(0xFFEDE7F6),
    Color(0xFFFFF9C4),
    Color(0xFFE8F5E9),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (ctx, _) {
        final notes = _appState.notes;
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: CustomScrollView(
            slivers: [
              const SliverAppBar(
                expandedHeight: 120,
                floating: true,
                pinned: true,
                backgroundColor: AppTheme.bg,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                  title: Text('Notes', style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5,
                  )),
                ),
              ),
              if (notes.isEmpty)
                const SliverFillRemaining(child: _EmptyState(
                  icon: Icons.sticky_note_2_outlined,
                  message: 'No notes yet',
                  sub: 'Tap + to capture your thoughts',
                ))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _NoteCard(note: notes[i]),
                      childCount: notes.length,
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: _GlowFAB(
            onTap: () => _showAddNoteSheet(context),
          ),
        );
      },
    );
  }

  void _showAddNoteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddNoteSheet(noteColors: _noteColors),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) => CupertinoActionSheet(
            title: Text(note.title),
            actions: [
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  _appState.deleteNote(note.id);
                  Navigator.pop(context);
                },
                child: const Text('Delete Note'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: note.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                note.content,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF3A3A4E),
                  height: 1.5,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _timeAgo(note.createdAt),
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF6A6A7E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _AddNoteSheet extends StatefulWidget {
  final List<Color> noteColors;
  const _AddNoteSheet({required this.noteColors});

  @override
  State<_AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<_AddNoteSheet> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.noteColors[math.Random().nextInt(widget.noteColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('New Note', style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary,
          )),
          const SizedBox(height: 16),
          _Field(controller: _titleCtrl, hint: 'Note title', autofocus: true),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: TextField(
              controller: _contentCtrl,
              maxLines: 4,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: const InputDecoration.collapsed(
                hintText: 'Write something...',
                hintStyle: TextStyle(color: AppTheme.textMuted),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: widget.noteColors.map((c) => GestureDetector(
              onTap: () => setState(() => _selectedColor = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                width: _selectedColor == c ? 28 : 22,
                height: _selectedColor == c ? 28 : 22,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedColor == c
                        ? AppTheme.textPrimary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text('Save Note', style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700,
              )),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_titleCtrl.text.trim().isEmpty) return;
    _appState.addNote(Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      createdAt: DateTime.now(),
      color: _selectedColor,
    ));
    Navigator.pop(context);
  }
}

// ─── Shared Widgets ──────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool autofocus;

  const _Field({
    required this.controller,
    required this.hint,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppTheme.textMuted),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _GlowFAB extends StatelessWidget {
  final VoidCallback onTap;
  const _GlowFAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: AppTheme.accent.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String sub;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border),
            ),
            child: Icon(icon, color: AppTheme.textMuted, size: 32),
          ),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: AppTheme.textSecondary,
          )),
          const SizedBox(height: 6),
          Text(sub, style: const TextStyle(
            fontSize: 13, color: AppTheme.textMuted,
          )),
        ],
      ),
    );
  }
}