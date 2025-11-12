import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../ai_chat_config.dart';
import 'chat_message.dart';
import 'media.dart';

/// 用于自定义聊天气泡外观的类
class BubbleStyle {
  /// 用户消息气泡的最大宽度
  final double? userBubbleMaxWidth;

  /// AI消息气泡的最大宽度
  final double? aiBubbleMaxWidth;

  /// 用户消息气泡的最小宽度
  final double? userBubbleMinWidth;

  /// AI消息气泡的最小宽度
  final double? aiBubbleMinWidth;

  /// 用户消息气泡的背景颜色
  final Color? userBubbleColor;

  /// AI消息气泡的背景颜色
  final Color? aiBubbleColor;

  /// 用户气泡中用户名的颜色
  final Color? userNameColor;

  /// AI 气泡中 AI 名称的颜色
  final Color? aiNameColor;

  /// 复制图标的颜色
  final Color? copyIconColor;

  /// 用户消息气泡的左上角半径
  final double? userBubbleTopLeftRadius;

  /// 用户消息气泡的右上角半径
  final double? userBubbleTopRightRadius;

  /// AI 消息气泡的左上角半径
  final double? aiBubbleTopLeftRadius;

  /// AI 消息气泡的右上角半径
  final double? aiBubbleTopRightRadius;

  /// 所有消息气泡的左下半径
  final double? bottomLeftRadius;

  /// 所有消息气泡的右下半径
  final double? bottomRightRadius;

  /// 是否显示消息气泡的阴影
  final bool enableShadow;

  /// 消息气泡的阴影不透明度
  final double? shadowOpacity;

  /// 消息气泡的阴影模糊半径
  final double? shadowBlurRadius;

  /// 消息气泡的阴影偏移
  final Offset? shadowOffset;

  const BubbleStyle({
    this.userBubbleMaxWidth,
    this.aiBubbleMaxWidth,
    this.userBubbleMinWidth,
    this.aiBubbleMinWidth,
    this.userBubbleColor,
    this.aiBubbleColor,
    this.userNameColor,
    this.aiNameColor,
    this.copyIconColor,
    this.userBubbleTopLeftRadius,
    this.userBubbleTopRightRadius,
    this.aiBubbleTopLeftRadius,
    this.aiBubbleTopRightRadius,
    this.bottomLeftRadius,
    this.bottomRightRadius,
    this.enableShadow = true,
    this.shadowOpacity,
    this.shadowBlurRadius,
    this.shadowOffset,
  });

  /// 消息气泡的默认样式
  static const BubbleStyle defaultStyle = BubbleStyle(
    userBubbleTopLeftRadius: 18,
    userBubbleTopRightRadius: 4,
    aiBubbleTopLeftRadius: 4,
    aiBubbleTopRightRadius: 18,
    bottomLeftRadius: 18,
    bottomRightRadius: 18,
    enableShadow: true,
    shadowOpacity: 0.08,
    shadowBlurRadius: 10,
    shadowOffset: Offset(0, 3),
  );

  /// 创建此 BubbleStyle 的副本，并替换给定字段
  BubbleStyle copyWith({
    double? userBubbleMaxWidth,
    double? aiBubbleMaxWidth,
    double? userBubbleMinWidth,
    double? aiBubbleMinWidth,
    Color? userBubbleColor,
    Color? aiBubbleColor,
    Color? userNameColor,
    Color? aiNameColor,
    Color? copyIconColor,
    double? userBubbleTopLeftRadius,
    double? userBubbleTopRightRadius,
    double? aiBubbleTopLeftRadius,
    double? aiBubbleTopRightRadius,
    double? bottomLeftRadius,
    double? bottomRightRadius,
    bool? enableShadow,
    double? shadowOpacity,
    double? shadowBlurRadius,
    Offset? shadowOffset,
  }) {
    return BubbleStyle(
      userBubbleMaxWidth: userBubbleMaxWidth ?? this.userBubbleMaxWidth,
      aiBubbleMaxWidth: aiBubbleMaxWidth ?? this.aiBubbleMaxWidth,
      userBubbleMinWidth: userBubbleMinWidth ?? this.userBubbleMinWidth,
      aiBubbleMinWidth: aiBubbleMinWidth ?? this.aiBubbleMinWidth,
      userBubbleColor: userBubbleColor ?? this.userBubbleColor,
      aiBubbleColor: aiBubbleColor ?? this.aiBubbleColor,
      userNameColor: userNameColor ?? this.userNameColor,
      aiNameColor: aiNameColor ?? this.aiNameColor,
      copyIconColor: copyIconColor ?? this.copyIconColor,
      userBubbleTopLeftRadius:
          userBubbleTopLeftRadius ?? this.userBubbleTopLeftRadius,
      userBubbleTopRightRadius:
          userBubbleTopRightRadius ?? this.userBubbleTopRightRadius,
      aiBubbleTopLeftRadius:
          aiBubbleTopLeftRadius ?? this.aiBubbleTopLeftRadius,
      aiBubbleTopRightRadius:
          aiBubbleTopRightRadius ?? this.aiBubbleTopRightRadius,
      bottomLeftRadius: bottomLeftRadius ?? this.bottomLeftRadius,
      bottomRightRadius: bottomRightRadius ?? this.bottomRightRadius,
      enableShadow: enableShadow ?? this.enableShadow,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
    );
  }
}

/// 用于自定义消息外观和行为的选项
class MessageOptions {
  /// 消息文本的样式
  final TextStyle? textStyle;

  /// 消息气泡周围的填充
  final EdgeInsets? padding;

  /// 消息气泡周围的边距
  final EdgeInsets? containerMargin;

  /// 消息气泡的装饰
  final BoxDecoration? decoration;

  /// 消息气泡的装饰（containerDecoration 是新名称）
  final BoxDecoration? containerDecoration;

  /// 消息气泡背景的颜色
  final Color? containerColor; // 添加是为了向后兼容

  /// 是否显示消息时间戳
  final bool showTime;

  /// 时间戳文本的样式
  final TextStyle? timeTextStyle;

  /// 格式化时间戳的函数
  final String Function(DateTime)? timeFormat;

  /// 消息气泡和时间戳之间的间距
  final double? timestampSpacing;

  /// 显示的最大反应数
  final int maxReactions;

  /// 反应气泡大小
  final double reactionSize;

  /// 是否启用快速回复
  final bool enableQuickReply;

  /// 消息气泡的样式选项
  ///
  /// 此属性允许自定义消息气泡的外观，
  /// 包括颜色、边框半径和阴影。
  ///
  /// 将使用 [bubbleStyle] 颜色（userBubbleColor 和 aiBubbleColor）
  /// 即使提供了装饰或containerDecoration。
  ///
  /// 要完全自定义气泡外观（覆盖 bubbleStyle）：
  /// 1. 设置 bubbleStyle 为 null
  /// 2.提供自定义装饰或containerDecoration
  final BubbleStyle? bubbleStyle;

  /// 是否显示用户名
  final bool? showUserName;

  /// 用户名的样式
  final TextStyle? userNameStyle;

  /// Markdown 内容的样式表
  final MarkdownStyleSheet? markdownStyleSheet;

  /// 点击链接时的回调
  final MarkdownTapLinkCallback? onTapLink;

  /// AI消息是否显示复制按钮
  final bool? showCopyButton;

  /// 消息复制时的回调
  final void Function(String)? onCopy;

  /// 用户消息文本的颜色
  final Color? userTextColor;

  /// AI 消息文本的颜色
  final Color? aiTextColor;

  /// 在消息中点击媒体时的回调
  final void Function(ChatMedia)? onMediaTap;

  /// 是否允许点击 Markdown 内容中的图像
  final bool enableImageTaps;

  /// 点击Markdown内容中的图片时的回调
  /// 提供图像 URL、标题和替代文本
  final void Function(String url, String? title, String? alt)? onImageTap;

  /// 自定义复制按钮的构建函数
  /// 
  /// 参数:
  /// - context: BuildContext
  /// - message: 当前消息对象
  /// - onCopyPressed: 复制按钮的点击回调
  /// 
  /// 返回自定义的复制按钮 Widget，如果返回 null 则使用默认实现
  final Widget Function(
    BuildContext context,
    ChatMessage message,
    VoidCallback onCopyPressed,
  )? copyButtonBuilder;

  /// 气泡内纯文本内容的自定义生成器
  ///
  /// 允许覆盖非 Markdown 消息文本的呈现方式，同时保留
  /// 默认的气泡布局完好无损。
  final Widget Function(
    BuildContext context,
    String text,
    TextStyle effectiveTextStyle,
    bool isUser,
  )? textBuilder;

  /// 气泡内降价内容的自定义生成器
  ///
  /// 允许覆盖 Markdown 消息内容的呈现方式，同时保留
  /// 默认的气泡布局完好无损。
  final Widget Function(
    BuildContext context,
    String text,
    MarkdownStyleSheet effectiveStyleSheet,
    bool isUser,
  )? markdownBuilder;

  /// 消息气泡的自定义生成器
  ///
  /// 该构建器允许完全替换默认消息气泡。
  /// 提供的参数有：
  /// -[BuildContext] context：构建上下文
  /// -[ChatMessage] 消息：正在呈现的消息
  /// -[bool] isUser: 该消息是否来自当前用户
  ///
  /// 返回一个完全自定义的小部件来替换整个气泡。
  /// 这提供了真正的定制，而不仅仅是包装默认的气泡。
  final Widget Function(BuildContext, ChatMessage, bool)? customBubbleBuilder;

  /// 创建 [MessageOptions] 的实例。
  ///
  /// 装饰注意事项：
  /// -如果提供了[bubbleStyle]，则其颜色设置将优先
  ///   [decoration] 和 [containerDecoration] 颜色。
  /// -使用 [bubbleStyle] 自定义气泡颜色、半径和阴影。
  /// -使用[decoration]或[containerDecoration]进行更高级的装饰
  ///   像渐变和图像，但要注意 [bubbleStyle] 颜色会
  ///   仍适用。
  /// -要完全绕过 [bubbleStyle]，请将其设置为 null 并仅使用
  ///   [装饰]或[容器装饰]。
  const MessageOptions({
    this.textStyle,
    this.padding,
    this.containerMargin,
    this.decoration,
    this.containerDecoration,
    this.containerColor,
    this.showTime = true,
    this.timeTextStyle,
    this.timeFormat,
    this.timestampSpacing,
    this.maxReactions = 5,
    this.reactionSize = 24.0,
    this.enableQuickReply = true,
    this.bubbleStyle,
    this.showUserName = true,
    this.userNameStyle,
    this.markdownStyleSheet,
    this.onTapLink,
    this.showCopyButton = false,
    this.onCopy,
    this.userTextColor,
    this.aiTextColor,
    this.onMediaTap,
    this.enableImageTaps = false,
    this.onImageTap,
    this.copyButtonBuilder,
    this.textBuilder,
    this.markdownBuilder,
    this.customBubbleBuilder,
  });

  MessageOptions copyWith({
    TextStyle? textStyle,
    EdgeInsets? padding,
    EdgeInsets? containerMargin,
    BoxDecoration? decoration,
    BoxDecoration? containerDecoration,
    Color? containerColor,
    bool? showTime,
    TextStyle? timeTextStyle,
    String Function(DateTime)? timeFormat,
    double? timestampSpacing,
    int? maxReactions,
    double? reactionSize,
    bool? enableQuickReply,
    BubbleStyle? bubbleStyle,
    bool? showUserName,
    TextStyle? userNameStyle,
    MarkdownStyleSheet? markdownStyleSheet,
    MarkdownTapLinkCallback? onTapLink,
    bool? showCopyButton,
    void Function(String)? onCopy,
    Color? userTextColor,
    Color? aiTextColor,
    void Function(ChatMedia)? onMediaTap,
    bool? enableImageTaps,
    void Function(String url, String? title, String? alt)? onImageTap,
    Widget Function(BuildContext, ChatMessage, VoidCallback)? copyButtonBuilder,
    Widget Function(BuildContext, String, TextStyle, bool)? textBuilder,
    Widget Function(BuildContext, String, MarkdownStyleSheet, bool)?
        markdownBuilder,
    Widget Function(BuildContext, ChatMessage, bool)? customBubbleBuilder,
  }) =>
      MessageOptions(
        textStyle: textStyle ?? this.textStyle,
        padding: padding ?? this.padding,
        containerMargin: containerMargin ?? this.containerMargin,
        decoration: decoration ?? this.decoration,
        containerDecoration: containerDecoration ?? this.containerDecoration,
        containerColor: containerColor ?? this.containerColor,
        showTime: showTime ?? this.showTime,
        timeTextStyle: timeTextStyle ?? this.timeTextStyle,
        timeFormat: timeFormat ?? this.timeFormat,
        timestampSpacing: timestampSpacing ?? this.timestampSpacing,
        maxReactions: maxReactions ?? this.maxReactions,
        reactionSize: reactionSize ?? this.reactionSize,
        enableQuickReply: enableQuickReply ?? this.enableQuickReply,
        bubbleStyle: bubbleStyle ?? this.bubbleStyle,
        showUserName: showUserName ?? this.showUserName,
        userNameStyle: userNameStyle ?? this.userNameStyle,
        markdownStyleSheet: markdownStyleSheet ?? this.markdownStyleSheet,
        onTapLink: onTapLink ?? this.onTapLink,
        showCopyButton: showCopyButton ?? this.showCopyButton,
        onCopy: onCopy ?? this.onCopy,
        userTextColor: userTextColor ?? this.userTextColor,
        aiTextColor: aiTextColor ?? this.aiTextColor,
        onMediaTap: onMediaTap ?? this.onMediaTap,
        enableImageTaps: enableImageTaps ?? this.enableImageTaps,
        onImageTap: onImageTap ?? this.onImageTap,
        copyButtonBuilder: copyButtonBuilder ?? this.copyButtonBuilder,
        textBuilder: textBuilder ?? this.textBuilder,
        markdownBuilder: markdownBuilder ?? this.markdownBuilder,
        customBubbleBuilder: customBubbleBuilder ?? this.customBubbleBuilder,
      );

  /// 通过回退到 containerColor 获得有效的装饰
  BoxDecoration? get effectiveDecoration {
    if (containerDecoration != null) {
      return containerDecoration;
    }
    if (decoration != null) {
      return decoration;
    }
    if (containerColor != null) {
      return BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
      );
    }
    return null;
  }
}

/// 用于自定义消息列表的选项
class MessageListOptions {
  /// 消息列表的自定义滚动控制器
  final ScrollController? scrollController;

  /// 消息列表的自定义滚动物理
  final ScrollPhysics? scrollPhysics;

  /// 消息之间的日期分隔符生成器
  final Widget Function(DateTime)? dateSeparatorBuilder;

  /// 加载更多消息时显示的小部件
  final Widget? loadingWidget;

  /// 通过按钮加载较早消息时的回调
  final Future<void> Function()? onLoadEarlier;

  /// 消息加载的分页配置
  final PaginationConfig paginationConfig;

  /// 当前是否正在加载更多消息
  final bool isLoadingMore;

  /// 是否还有更多消息需要加载
  final bool hasMoreMessages;

  /// 滚动触发自动加载更多消息时的回调
  final Future<void> Function()? onLoadMore;

  const MessageListOptions({
    this.scrollController,
    this.scrollPhysics,
    this.dateSeparatorBuilder,
    this.loadingWidget,
    this.onLoadEarlier,
    this.paginationConfig = const PaginationConfig(),
    this.isLoadingMore = false,
    this.hasMoreMessages = true,
    this.onLoadMore,
  });

  MessageListOptions copyWith({
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    Widget Function(DateTime)? dateSeparatorBuilder,
    Widget? loadingWidget,
    Future<void> Function()? onLoadEarlier,
    PaginationConfig? paginationConfig,
    bool? isLoadingMore,
    bool? hasMoreMessages,
    Future<void> Function()? onLoadMore,
  }) =>
      MessageListOptions(
        scrollController: scrollController ?? this.scrollController,
        scrollPhysics: scrollPhysics ?? this.scrollPhysics,
        dateSeparatorBuilder: dateSeparatorBuilder ?? this.dateSeparatorBuilder,
        loadingWidget: loadingWidget ?? this.loadingWidget,
        onLoadEarlier: onLoadEarlier ?? this.onLoadEarlier,
        paginationConfig: paginationConfig ?? this.paginationConfig,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
        onLoadMore: onLoadMore ?? this.onLoadMore,
      );
}

/// 自定义快速回复的选项
class QuickReplyOptions {
  /// 快速回复选项列表
  final List<String>? quickReplies;

  /// 点击快速回复时的回调
  final void Function(String)? onQuickReplyTap;

  /// 快速回复按钮的装饰
  final BoxDecoration? decoration;

  /// 快速回复按钮的文本样式
  final TextStyle? textStyle;

  const QuickReplyOptions({
    this.quickReplies,
    this.onQuickReplyTap,
    this.decoration,
    this.textStyle,
  });

  QuickReplyOptions copyWith({
    List<String>? quickReplies,
    void Function(String)? onQuickReplyTap,
    BoxDecoration? decoration,
    TextStyle? textStyle,
  }) =>
      QuickReplyOptions(
        quickReplies: quickReplies ?? this.quickReplies,
        onQuickReplyTap: onQuickReplyTap ?? this.onQuickReplyTap,
        decoration: decoration ?? this.decoration,
        textStyle: textStyle ?? this.textStyle,
      );
}

/// 用于自定义滚动到底部按钮的选项
///
/// 此按钮允许用户快速滚动到最新消息。
/// -在时间顺序模式下（reverseOrder: false），它滚动到列表的底部。
/// -在反向模式下（reverseOrder：true），它滚动到列表顶部。
class ScrollToBottomOptions {
  /// 是否禁用滚动到底部按钮
  final bool disabled;

  /// 是否始终显示滚动到底部按钮
  final bool alwaysVisible;

  /// 按下滚动到底部按钮时的回调
  final VoidCallback? onScrollToBottomPress;

  /// 用于滚动到底部按钮的自定义构建器
  final Widget Function(ScrollController)? scrollToBottomBuilder;

  /// 距屏幕底部的距离（默认为 72）
  final double bottomOffset;

  /// 距屏幕右侧的距离（默认为 16）
  final double rightOffset;

  /// 是否在图标旁边显示文本（默认为true）
  final bool showText;

  /// 显示在图标旁边的自定义文本（默认为“滚动到底部”）
  final String buttonText;

  const ScrollToBottomOptions({
    this.disabled = false,
    this.alwaysVisible = false,
    this.onScrollToBottomPress,
    this.scrollToBottomBuilder,
    this.bottomOffset = 72,
    this.rightOffset = 16,
    this.showText = false,
    this.buttonText = 'Scroll to bottom',
  });

  ScrollToBottomOptions copyWith({
    bool? disabled,
    bool? alwaysVisible,
    VoidCallback? onScrollToBottomPress,
    Widget Function(ScrollController)? scrollToBottomBuilder,
    double? bottomOffset,
    double? rightOffset,
    bool? showText,
    String? buttonText,
  }) =>
      ScrollToBottomOptions(
        disabled: disabled ?? this.disabled,
        alwaysVisible: alwaysVisible ?? this.alwaysVisible,
        onScrollToBottomPress:
            onScrollToBottomPress ?? this.onScrollToBottomPress,
        scrollToBottomBuilder:
            scrollToBottomBuilder ?? this.scrollToBottomBuilder,
        bottomOffset: bottomOffset ?? this.bottomOffset,
        rightOffset: rightOffset ?? this.rightOffset,
        showText: showText ?? this.showText,
        buttonText: buttonText ?? this.buttonText,
      );
}
