import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_choice_chip.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../domain/entities/lesson_query.dart';
import '../cubit/course_cubit.dart';
import '../cubit/course_state.dart';
import '../lesson_query_labels.dart';

class LessonToolbar extends StatefulWidget {
  const LessonToolbar({super.key});

  @override
  State<LessonToolbar> createState() => _LessonToolbarState();
}

class _LessonToolbarState extends State<LessonToolbar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: context.read<CourseCubit>().state.query.search);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CourseCubit>();

    return BlocConsumer<CourseCubit, CourseState>(
      listenWhen: (previous, current) => previous.query.search != current.query.search,
      listener: (context, state) {
        if (_controller.text != state.query.search) _controller.text = state.query.search;
      },
      buildWhen: (previous, current) =>
          previous.query != current.query || previous.visibleLessons.length != current.visibleLessons.length,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppSearchField(controller: _controller, onChanged: cubit.search, hint: 'Search lessons'),
                ),
                const SizedBox(width: 8),
                _SortMenu(current: state.query.sort, onSelected: cubit.setSort),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final filter in LessonFilter.values)
                  AppChoiceChip(
                    key: Key('filter_${filter.name}'),
                    label: filter.label,
                    selected: state.query.filter == filter,
                    onSelected: () => cubit.setFilter(filter),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${state.visibleLessons.length} lessons · ${state.query.sort.label}',
              key: const Key('result_summary'),
              style: AppTextStyles.caption,
            ),
          ],
        );
      },
    );
  }
}

class _SortMenu extends StatelessWidget {
  const _SortMenu({required this.current, required this.onSelected});

  final LessonSort current;
  final ValueChanged<LessonSort> onSelected;

  @override
  Widget build(BuildContext context) {
    final active = current != LessonSort.defaultOrder;
    return PopupMenuButton<LessonSort>(
      key: const Key('sort_menu'),
      tooltip: 'Sort lessons',
      initialValue: current,
      onSelected: onSelected,
      style: IconButton.styleFrom(
        fixedSize: const Size.square(48),
        backgroundColor: active ? AppColors.primary : AppColors.surface,
        side: BorderSide(color: active ? AppColors.primary : AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: Icon(Icons.sort, color: active ? Colors.white : AppColors.ink),
      itemBuilder: (context) => [
        for (final sort in LessonSort.values)
          CheckedPopupMenuItem(
            key: Key('sort_${sort.name}'),
            value: sort,
            checked: sort == current,
            child: Text(sort.label),
          ),
      ],
    );
  }
}
