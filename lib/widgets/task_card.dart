import 'package:flutter/material.dart';
import 'package:mdm/models/task.dart';
import 'package:mdm/models/vo/task.pb.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onDelete;
  final VoidCallback onRetry;

  const TaskCard({
    super.key,
    required this.task,
    required this.isSelected,
    required this.onTap,
    required this.onPause,
    required this.onResume,
    required this.onDelete,
    required this.onRetry,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: widget.isSelected
                  ? LinearGradient(
                colors: [
                  const Color(0xFF667EEA).withOpacity(0.2),
                  const Color(0xFF764BA2).withOpacity(0.1),
                ],
              )
                  : null,
              color: widget.isSelected ? null : const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected
                    ? const Color(0xFF667EEA).withOpacity(0.5)
                    : _isHovered
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
                width: widget.isSelected ? 2 : 1,
              ),
              boxShadow: _isHovered
                  ? [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
                  : null,
            ),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildProgressSection(),
                const SizedBox(height: 16),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildFileIcon(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStatusBadge(),
                  const SizedBox(width: 8),
                  if (widget.task.category != null)
                    _buildCategoryBadge(),
                ],
              ),
            ],
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildFileIcon() {
    final iconData = _getFileIcon(widget.task.name);
    final color = _getStatusColor(widget.task.phase);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: color,
        size: 24,
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
        return Icons.folder_zip_rounded;
      case 'exe':
      case 'dmg':
      case 'pkg':
      case 'msi':
        return Icons.install_desktop_rounded;
      case 'iso':
        return Icons.album_rounded;
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'mp4':
      case 'mkv':
      case 'avi':
      case 'mov':
        return Icons.video_file_rounded;
      case 'mp3':
      case 'wav':
      case 'flac':
        return Icons.audio_file_rounded;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Widget _buildStatusBadge() {
    final color = _getStatusColor(widget.task.phase);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.task.phase == TaskPhase.TpDownRunning)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            )
          else
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: 6),
          Text(
            widget.task.phase.label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.task.category.name,
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (widget.task.phase == TaskPhase.TpDownRunning)
          _buildIconButton(
            icon: Icons.pause_rounded,
            color: const Color(0xFFFFBE0B),
            onPressed: widget.onPause,
            tooltip: 'Pause',
          ),
        if (widget.task.phase == TaskPhase.TpDownPaused)
          _buildIconButton(
            icon: Icons.play_arrow_rounded,
            color: const Color(0xFF4ECDC4),
            onPressed: widget.onResume,
            tooltip: 'Resume',
          ),
        if (widget.task.phase == TaskPhase.TpDownFailed)
          _buildIconButton(
            icon: Icons.refresh_rounded,
            color: const Color(0xFF667EEA),
            onPressed: widget.onRetry,
            tooltip: 'Retry',
          ),
        const SizedBox(width: 8),
        _buildIconButton(
          icon: Icons.delete_outline_rounded,
          color: const Color(0xFFFF6B6B),
          onPressed: widget.onDelete,
          tooltip: 'Delete',
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    final progress = widget.task.downloadStats.progress;
    final color = _getStatusColor(widget.task.phase);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 8,
                width: MediaQuery.of(context).size.width * (widget.task.downloadStats.progress.toDouble()/widget.task.size.toDouble()) * 0.4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.task.phase == TaskPhase.TpDownRunning
                        ? [const Color(0xFF4ECDC4), const Color(0xFF44A08D)]
                        : [color, color.withOpacity(0.7)],
                  ),
                  boxShadow: widget.task.phase == TaskPhase.TpDownRunning
                      ? [
                    BoxShadow(
                      color: const Color(0xFF4ECDC4).withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ]
                      : null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(widget.task.downloadStats.progress.toDouble()/widget.task.size.toDouble() * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_formatSize(widget.task.downloadStats.progress.toInt())} / ${_formatSize(widget.task.size.toInt())}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        if (widget.task.phase == TaskPhase.TpDownRunning) ...[
          Icon(
            Icons.speed_rounded,
            color: Colors.white.withOpacity(0.4),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            '${_formatSpeed(widget.task.downloadStats.speed.toDouble())}/s',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.timer_outlined,
            color: Colors.white.withOpacity(0.4),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            _formatDuration(Duration(seconds: ((widget.task.size.toInt()-widget.task.downloadStats.progress.toInt())/widget.task.downloadStats.speed.toInt()).toInt())),
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ],
        const Spacer(),
        Icon(
          Icons.access_time_rounded,
          color: Colors.white.withOpacity(0.3),
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          _formatDateTime(DateTime.fromMillisecondsSinceEpoch(widget.task.createdAt.toInt()*1000)),
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(TaskPhase status) {
    switch (status) {
      case TaskPhase.TpDownRunning:
        return const Color(0xFF4ECDC4);
      case TaskPhase.TpDownCompleted:
        return const Color(0xFF00FF88);
      case TaskPhase.TpDownPaused:
        return const Color(0xFFFFBE0B);
      case TaskPhase.TpDownFailed:
        return const Color(0xFFFF6B6B);
      case TaskPhase.TpDownWaiting:
        return const Color(0xFF9CA3AF);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String _formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond < 1024) return '${bytesPerSecond.toStringAsFixed(0)} B';
    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return '--:--';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }
}