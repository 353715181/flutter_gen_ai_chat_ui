import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../controllers/chat_messages_controller.dart';
import '../models/ai_chat_config.dart';
import '../models/chat/models.dart';
import '../models/example_question.dart';
import '../models/example_question_config.dart' hide ExampleQuestion;
import '../models/file_upload_options.dart';
import '../models/input_options.dart';
import '../models/welcome_message_config.dart';
import '../utils/color_extensions.dart';
import 'chat_input.dart';
import 'custom_chat_widget.dart';

/// 用于 AI 对话的可定制聊天小部件。
class AiChatWidget extends StatefulWidget {
  const AiChatWidget({
    super.key,
    // 所需参数与 Dila 类似
    required this.currentUser,
    required this.aiUser,
    required this.controller,
    required this.onSendMessage,

    // 可选参数，类似于Dila的方法
    this.messages,
    this.inputOptions,
    this.messageOptions,
    this.messageListOptions,
    this.typingUsers,
    this.readOnly = false,
    this.quickReplyOptions,
    this.scrollToBottomOptions,
    this.scrollController,

    // 特定于 AI 功能的可选选项
    this.welcomeMessageConfig,
    this.exampleQuestions = const [],
    this.persistentExampleQuestions = false,
    this.enableAnimation = true,
    this.maxWidth,
    this.loadingConfig,
    this.paginationConfig,
    this.padding,
    this.enableMarkdownStreaming = true,
    this.streamingDuration = const Duration(milliseconds: 30),
    this.markdownStyleSheet,
    this.aiName = 'AI',
    // 流媒体淡入（可选，为简单起见默认关闭）
    this.streamingFadeInDuration,
    this.streamingFadeInCurve,
    this.streamingFadeInEnabled,
    this.streamingWordByWord,

    // 滚动行为配置
    this.scrollBehaviorConfig,

    // 新参数
    this.fileUploadOptions,
  });

  /// 对话中的当前用户
  final ChatUser currentUser;

  /// 对话中的AI助手
  final ChatUser aiUser;

  /// AI助手名称（显示）
  final String aiName;

  /// 管理聊天消息的控制器
  final ChatMessagesController controller;

  /// 消息发送时回调
  final void Function(ChatMessage) onSendMessage;

  /// 可选消息列表（如果不使用控制器）
  final List<ChatMessage>? messages;

  /// 输入字段的自定义选项
  final InputOptions? inputOptions;

  /// 消息的自定义选项
  final MessageOptions? messageOptions;

  /// 消息列表的自定义选项
  final MessageListOptions? messageListOptions;

  /// 用于快速回复的自定义选项
  final QuickReplyOptions? quickReplyOptions;

  /// 滚动到底部按钮的自定义选项
  final ScrollToBottomOptions? scrollToBottomOptions;

  /// 当前正在打字的用户
  final List<ChatUser>? typingUsers;

  /// 聊天界面是否为只读模式
  final bool readOnly;

  /// 可选的滚动控制器
  final ScrollController? scrollController;

  /// 欢迎消息的配置。
  /// 提供后，欢迎消息将在对话开始时显示。
  /// 如果该值为 null 并且 exampleQuestions 为空，则不会显示欢迎消息。
  final WelcomeMessageConfig? welcomeMessageConfig;

  /// 欢迎消息中显示的示例问题。
  /// 当非空时，这些将在对话开始时启用欢迎消息
  /// 即使welcomeMessageConfig 为空。
  final List<ExampleQuestion> exampleQuestions;

  /// 是否持续显示例题
  final bool persistentExampleQuestions;

  /// 是否启用动画
  final bool enableAnimation;

  /// 聊天小部件的最大宽度
  final double? maxWidth;

  /// 加载状态配置
  final LoadingConfig? loadingConfig;

  /// 分页配置
  final PaginationConfig? paginationConfig;

  /// 整个小部件周围的填充
  final EdgeInsets? padding;

  /// 是否启用markdown流式动画
  final bool enableMarkdownStreaming;

  /// 流式动画的持续时间
  final Duration streamingDuration;

  /// Markdown 渲染的样式表
  final MarkdownStyleSheet? markdownStyleSheet;

  /// 用于流文本的可选淡入配置
  /// 如果未提供，则禁用淡入以实现更简单的默认设置。
  final Duration? streamingFadeInDuration;
  final Curve? streamingFadeInCurve;
  final bool? streamingFadeInEnabled;
  final bool? streamingWordByWord;

  /// 滚动行为的配置
  final ScrollBehaviorConfig? scrollBehaviorConfig;

  /// 可选文件上传选项
  final FileUploadOptions? fileUploadOptions;

  @override
  State<AiChatWidget> createState() => _AiChatWidgetState();
}

class _AiChatWidgetState extends State<AiChatWidget>
    with TickerProviderStateMixin {
  late ScrollController _effectiveScrollController;
  late AnimationController _animationController;
  late TextEditingController _textController;
  late FocusNode _inputFocusNode;
  bool _isComposing = false;
  VoidCallback? _textControllerListener;

  @override
  void initState() {
    super.initState();
    _effectiveScrollController = widget.scrollController ?? ScrollController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.forward();

    _textController =
        widget.inputOptions?.textController ?? TextEditingController();
    _inputFocusNode = widget.inputOptions?.focusNode ?? FocusNode();

    // 创建并存储监听器以防止内存泄漏
    _textControllerListener = () {
      final isComposing = _textController.text.isNotEmpty;
      if (isComposing != _isComposing) {
        setState(() {
          _isComposing = isComposing;
        });
      }
    };

    _textController.addListener(_textControllerListener!);

    // 设置滚动行为配置
    if (widget.scrollBehaviorConfig != null) {
      widget.controller.scrollBehaviorConfig = widget.scrollBehaviorConfig;
      debugPrint('AiChatWidget: Initially set scroll behavior to: '
          '${widget.scrollBehaviorConfig!.autoScrollBehavior}, '
          'scrollToFirstMessage: ${widget.scrollBehaviorConfig!.scrollToFirstResponseMessage}');
    }

    // 根据配置设置欢迎消息可见性
    final hasWelcomeConfig = widget.welcomeMessageConfig != null;
    final hasExampleQuestions = widget.exampleQuestions.isNotEmpty;

    // 调试检查示例问题
    debugPrint('AiChatWidget: Has welcome config: $hasWelcomeConfig');
    debugPrint(
        'AiChatWidget: Has example questions: $hasExampleQuestions (count: ${widget.exampleQuestions.length})');
    if (hasExampleQuestions) {
      for (var i = 0; i < widget.exampleQuestions.length; i++) {
        debugPrint('  Question $i: ${widget.exampleQuestions[i].question}');
      }
    }
    debugPrint(
        'AiChatWidget: Current message count: ${widget.controller.messages.length}');

    // 仅在提供欢迎配置或示例问题时才显示欢迎消息
    if ((hasWelcomeConfig || hasExampleQuestions) &&
        widget.controller.messages.isEmpty) {
      debugPrint('AiChatWidget: Setting showWelcomeMessage to true');
      widget.controller.showWelcomeMessage = true;
    } else {
      debugPrint(
          'AiChatWidget: Not showing welcome message. Conditions not met.');
    }
  }

  @override
  void didUpdateWidget(AiChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 检查滚动行为配置是否已更改
    if (widget.scrollBehaviorConfig != oldWidget.scrollBehaviorConfig) {
      if (widget.scrollBehaviorConfig != null) {
        widget.controller.scrollBehaviorConfig = widget.scrollBehaviorConfig;
        debugPrint('AiChatWidget: Updated scroll behavior config to: '
            '${widget.scrollBehaviorConfig!.autoScrollBehavior}, '
            'scrollToFirstMessage: ${widget.scrollBehaviorConfig!.scrollToFirstResponseMessage}');
      }
    }
  }

  void _handleSend(final ChatMessage message) {
    // 首先隐藏欢迎消息，就像示例问题一样
    if (widget.controller.showWelcomeMessage) {
      widget.controller.hideWelcomeMessage();
    }

    widget.onSendMessage(message);
  }

  void handleExampleQuestionTap(final String question) {
    // 首先隐藏欢迎信息
    widget.controller.hideWelcomeMessage();

    // 创建并发送消息
    final message = ChatMessage(
      text: question,
      user: widget.currentUser,
      createdAt: DateTime.now(),
    );

    // 调用onSendMessage回调触发AI响应
    widget.onSendMessage(message);
  }

  /// 返回有效打字用户列表，包括加载时的AI用户
  /// 如果没有提供其他打字用户
  List<ChatUser> _getEffectiveTypingUsers() {
    final isLoading = widget.loadingConfig?.isLoading ?? false;

    // 如果我们明确设置了输入用户，则无论加载状态如何都使用这些用户
    if (widget.typingUsers != null && widget.typingUsers!.isNotEmpty) {
      return widget.typingUsers!;
    }

    // 如果我们正在加载并且没有打字用户，请将 AI 用户添加为打字用户
    if (isLoading) {
      return [widget.aiUser];
    }

    // 没有打字用户
    return [];
  }

  @override
  Widget build(final BuildContext context) => ListenableBuilder(
        listenable: widget.controller,
        builder: (final context, final child) => Container(
          width: widget.maxWidth,
          constraints: widget.maxWidth != null
              ? BoxConstraints(maxWidth: widget.maxWidth!)
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 如果启用并隐藏欢迎消息，则显示持续的示例问题
              if (!widget.controller.showWelcomeMessage &&
                  widget.persistentExampleQuestions &&
                  widget.exampleQuestions.isNotEmpty) ...[
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.15,
                  ),
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 4,
                    bottom: 12,
                  ),
                  child: _buildPersistentExampleQuestions(context),
                ),
              ],
              Expanded(
                child: CustomChatWidget(
                  padding: widget.padding,
                  controller: widget.controller,
                  currentUser: widget.currentUser,
                  messages: widget.messages ?? widget.controller.messages,
                  onSend: _handleSend,
                  messageOptions:
                      widget.messageOptions ?? const MessageOptions(),
                  inputOptions: widget.inputOptions ?? const InputOptions(),
                  typingUsers: _getEffectiveTypingUsers(),
                  messageListOptions:
                      (widget.messageListOptions ?? const MessageListOptions())
                          .copyWith(
                    scrollController: _effectiveScrollController,
                  ),
                  readOnly: widget.readOnly,
                  quickReplyOptions:
                      widget.quickReplyOptions ?? const QuickReplyOptions(),
                  scrollToBottomOptions: widget.scrollToBottomOptions ??
                      const ScrollToBottomOptions(),
                  typingIndicator: (widget.loadingConfig?.isLoading ?? false)
                      ? widget.loadingConfig?.loadingIndicator
                      : null,
                  welcomeMessageConfig: widget.welcomeMessageConfig,
                  exampleQuestions: widget.exampleQuestions,
                  // 将流配置传递给渲染器
                  streamingTypingSpeed: widget.streamingDuration,
                  streamingEnabled: widget.enableMarkdownStreaming,
                  streamingFadeInEnabled:
                      widget.streamingFadeInEnabled ?? false,
                  streamingFadeInDuration: widget.streamingFadeInDuration ??
                      const Duration(milliseconds: 260),
                  streamingFadeInCurve:
                      widget.streamingFadeInCurve ?? Curves.easeInOut,
                  streamingWordByWord: widget.streamingWordByWord ?? false,
                ),
              ),
              // 加载指示器覆盖
              if ((widget.loadingConfig?.isLoading ?? false) &&
                  (widget.loadingConfig?.showCenteredIndicator ?? false))
                Container(
                  color: Colors.black26,
                  child: Center(
                    child: widget.loadingConfig?.loadingIndicator ??
                        const CircularProgressIndicator(),
                  ),
                ),
              // 在底部输入而不是定位
              if (!widget.readOnly)
                (widget.inputOptions?.useOuterContainer == false)
                    ? Container(
                        // 底片式容器
                        width: double.infinity,
                        decoration: widget.inputOptions?.containerDecoration,
                        padding: EdgeInsets.only(
                          left: widget.inputOptions?.padding?.left ?? 16,
                          right: widget.inputOptions?.padding?.right ?? 16,
                          top: widget.inputOptions?.padding?.top ?? 16,
                          bottom: (widget.inputOptions?.padding?.bottom ?? 16) +
                              MediaQuery.of(context).viewInsets.bottom +
                              MediaQuery.of(context).padding.bottom,
                        ),
                        child: _buildChatInput(),
                      )
                    : Material(
                        elevation: widget.inputOptions?.materialElevation ?? 0,
                        color:
                            widget.inputOptions?.useScaffoldBackground == true
                                ? Theme.of(context).scaffoldBackgroundColor
                                : widget.inputOptions?.materialColor,
                        shape: widget.inputOptions?.materialShape ??
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                              side: BorderSide.none,
                            ),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          padding: widget.inputOptions?.materialPadding ??
                              const EdgeInsets.all(8.0),
                          child: _buildChatInput(),
                        ),
                      ),
            ],
          ),
        ),
      );

  // 欢迎消息现在作为消息列表的一部分在 CustomChatWidget 中处理

  // 添加一种新方法，用于仅构建示例问题而无需欢迎消息
  Widget _buildPersistentExampleQuestions(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    // 获取第一个问题的默认配置（如果有）
    final defaultQuestionConfig = widget.exampleQuestions.isNotEmpty
        ? widget.exampleQuestions.first.config
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1E2026).withOpacityCompat(0.9)
            : Colors.white.withOpacityCompat(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityCompat(isDarkMode ? 0.2 : 0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: -5,
          ),
        ],
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacityCompat(0.1)
              : Colors.black.withOpacityCompat(0.05),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
            child: Text(
              'Suggested Questions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.exampleQuestions.map(
                  (question) {
                    // 获取问题的配置或使用默认值
                    final effectiveConfig =
                        question.config ?? defaultQuestionConfig;
                    return _buildPersistentQuestionChip(
                      question,
                      effectiveConfig ?? const ExampleQuestionConfig(),
                      isDarkMode,
                      primaryColor,
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 以更紧凑的形式构建问题芯片的新方法
  Widget _buildPersistentQuestionChip(
    ExampleQuestion question,
    ExampleQuestionConfig effectiveConfig,
    bool isDarkMode,
    Color primaryColor,
  ) {
    final chipColor = isDarkMode
        ? primaryColor.withOpacityCompat(0.15)
        : primaryColor.withOpacityCompat(0.08);

    return InkWell(
      onTap: () => handleExampleQuestionTap(question.question),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primaryColor.withOpacityCompat(0.2),
            width: 1,
          ),
        ),
        child: Text(
          question.question,
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // 构建聊天输入栏
  Widget _buildChatInput() {
    return ChatInput(
      controller: _textController,
      onSend: () {
        if (_textController.text.trim().isNotEmpty) {
          final message = ChatMessage(
            text: _textController.text.trim(),
            user: widget.currentUser,
            createdAt: DateTime.now(),
          );
          _textController.clear();
          _handleSend(message);
        }
      },
      options: widget.inputOptions ?? const InputOptions(),
      focusNode: _inputFocusNode,
      fileUploadOptions: widget.fileUploadOptions,
    );
  }

  @override
  void dispose() {
    // 如果我们创建了滚动控制器，则仅处理它
    if (widget.scrollController == null) {
      _effectiveScrollController.dispose();
    }
    _animationController.dispose();

    // 删除文本控制器侦听器以防止内存泄漏
    if (_textControllerListener != null) {
      _textController.removeListener(_textControllerListener!);
    }

    // 如果使用外部控制器，请勿丢弃
    if (widget.inputOptions?.textController == null) {
      _textController.dispose();
    }

    // 如果使用外部焦点节点，请勿丢弃
    if (widget.inputOptions?.focusNode == null) {
      _inputFocusNode.dispose();
    }
    super.dispose();
  }
}
