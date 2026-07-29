import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/document_controller.dart';
import '../design/app_colors.dart';
import '../models/document_item.dart';
import '../widgets/ll_ui.dart';

class DocumentsScreen extends GetView<DocumentController> {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              decoration: const BoxDecoration(
                gradient: AppColors.headerGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LlBackButton(),
                  const SizedBox(height: 14),
                  Obx(
                    () => LlTitleBlock(
                      title: 'docs_title'.tr,
                      subtitle: controller.isSeller.value
                          ? 'docs_subtitle_seller'.tr
                          : 'docs_subtitle_buyer'.tr,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.documents.isEmpty &&
                    controller.isSeller.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchDocuments,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    children: [
                      if (controller.isSeller.value)
                        _sellerUploadCard()
                      else
                        _buyerLookupCard(),
                      const SizedBox(height: 18),
                      Text(
                        controller.isSeller.value
                            ? 'docs_list_title'.tr
                            : 'docs_list_title_buyer'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (controller.documents.isEmpty)
                        LlSurfaceCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.folder_open_rounded,
                                size: 40,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'docs_empty_title'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                controller.isSeller.value
                                    ? 'docs_empty_desc_seller'.tr
                                    : 'docs_empty_desc_buyer'.tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...controller.documents.map(
                          (doc) => _DocumentCard(
                            document: doc,
                            canDelete: controller.isSeller.value,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sellerUploadCard() {
    return LlSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'docs_upload_section'.tr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'docs_select_plot_hint'.tr,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.sellerPlots.isEmpty) {
              return Text(
                'docs_no_linked_plots'.tr,
                style: const TextStyle(color: AppColors.danger, fontSize: 13),
              );
            }
            return DropdownButtonFormField<int>(
              value: controller.selectedPlotId.value,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                labelText: 'docs_plot_label'.tr,
              ),
              items: controller.sellerPlots
                  .map(
                    (plot) => DropdownMenuItem<int>(
                      value: int.tryParse('${plot['id']}'),
                      child: Text(
                        controller.plotLabel(plot),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: controller.onSellerPlotChanged,
            );
          }),
          const SizedBox(height: 12),
          Text(
            'docs_type_label'.tr,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedType.value,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: DocumentController.documentTypes
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(controller.typeLabel(type)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) controller.selectedType.value = value;
              },
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => LlPrimaryButton(
              label: 'docs_upload_btn'.tr,
              onPressed: controller.pickAndUpload,
              isLoading: controller.isUploading.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buyerLookupCard() {
    return LlSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'docs_buyer_lookup_title'.tr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'docs_buyer_lookup_hint'.tr,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.buyerPlotController,
            decoration: InputDecoration(
              hintText: 'PLOT-001',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              labelText: 'docs_plot_label'.tr,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => controller.fetchDocuments(),
          ),
          const SizedBox(height: 12),
          LlPrimaryButton(
            label: 'docs_view_plot_docs'.tr,
            onPressed: controller.fetchDocuments,
            icon: Icons.search_rounded,
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.canDelete,
  });

  final DocumentItem document;
  final bool canDelete;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentController>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: LlSurfaceCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.brand.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: AppColors.brand,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.originalName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          if (document.plotReference != null)
                            document.plotReference!,
                          controller.typeLabel(document.documentType),
                          document.sizeFormatted,
                        ].join(' · '),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.downloadAndOpen(document),
                    icon: const Icon(Icons.visibility_rounded, size: 16),
                    label: Text(
                      canDelete ? 'docs_open'.tr : 'docs_view_only'.tr,
                    ),
                  ),
                ),
                if (canDelete) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => controller.deleteDocument(document),
                    icon: const Icon(Icons.delete_outline_rounded),
                    color: AppColors.danger,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
