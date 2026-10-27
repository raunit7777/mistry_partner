import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../res/const_color.dart';
import '../../../res/const_text.dart';
import '../../order/view_model/term_view_model.dart';

class PolicyDetailScreen extends StatefulWidget {
  final dynamic slug;

  const PolicyDetailScreen({
    super.key,
    required this.slug,
  });

  @override
  State<PolicyDetailScreen> createState() => _PolicyDetailScreenState();
}

class _PolicyDetailScreenState extends State<PolicyDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TermViewModel>(context, listen: false).bookingApi(context, widget.slug);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5, // Thoda elevation diya hai taaki scroll pe alag dikhe
        centerTitle: true,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        // Yahan title dynamic rakha hai
        title: Consumer<TermViewModel>(
          builder: (context, policesVm, child) {
            final title = policesVm.bannerListData?.data?.policy?.title ?? "Details";
            return CustomText.bold(
              title,
              color: ColorConst.black,
              fontSize: 17,
            );
          },
        ),
      ),
      body: Consumer<TermViewModel>(
        builder: (context, policesVm, child) {
          if (policesVm.isLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final currentPolicy = policesVm.bannerListData?.data?.policy;

          if (currentPolicy == null) {
            return const Center(child: Text("Policy content nahi mila."));
          }

          final String htmlContent = currentPolicy.content ??
              "<h2>${currentPolicy.title}</h2><p>Content is currently unavailable.</p>";

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), // Thoda aur rounded
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Html(
                data: htmlContent,
                style: {
                  "body": Style(
                    fontSize: FontSize(14.5),
                    lineHeight: LineHeight.em(1.6),
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                  "h2": Style(
                    fontSize: FontSize(20.0),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0B301D),
                    margin: Margins.only(bottom: 16),
                  ),
                  "h3": Style(
                    fontSize: FontSize(16.0),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                    margin: Margins.only(top: 10, bottom: 8),
                  ),
                  "p": Style(
                    fontSize: FontSize(14.0),
                    color: Colors.grey.shade700,
                    margin: Margins.only(bottom: 12),
                  ),
                  "ul": Style(
                    padding: HtmlPaddings.only(left: 20),
                    margin: Margins.only(bottom: 10),
                  ),
                  "li": Style(
                    fontSize: FontSize(14.0),
                    color: Colors.grey.shade700,
                    margin: Margins.only(bottom: 6),
                  ),
                },
              ),
            ),
          );
        },
      ),
    );
  }
}