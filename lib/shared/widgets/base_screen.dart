import 'package:flutter/material.dart';
import 'package:adisyonapp/shared/widgets/loading_indicator.dart';

class BaseScreen extends StatelessWidget {
  final String? title;
  final Widget body;
  final bool isLoading;
  final String? loadingMessage;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final Widget? leading;

  const BaseScreen({
    super.key,
    this.title,
    required this.body,
    this.isLoading = false,
    this.loadingMessage,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.bottom,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null || actions != null
          ? AppBar(
              title: title != null ? Text(title!) : null,
              actions: actions,
              automaticallyImplyLeading: automaticallyImplyLeading,
              bottom: bottom,
              leading: leading,
            )
          : null,
      body: LoadingOverlay(
        isLoading: isLoading,
        message: loadingMessage,
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      backgroundColor: backgroundColor,
    );
  }
}

class BaseScrollScreen extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final bool isLoading;
  final String? loadingMessage;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final EdgeInsets padding;
  final bool reverse;
  final ScrollController? controller;
  final ScrollPhysics? physics;

  const BaseScrollScreen({
    super.key,
    this.title,
    required this.children,
    this.isLoading = false,
    this.loadingMessage,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.bottom,
    this.leading,
    this.padding = const EdgeInsets.all(16),
    this.reverse = false,
    this.controller,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: title,
      isLoading: isLoading,
      loadingMessage: loadingMessage,
      actions: actions,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      bottom: bottom,
      leading: leading,
      body: SingleChildScrollView(
        padding: padding,
        reverse: reverse,
        controller: controller,
        physics: physics,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
} 