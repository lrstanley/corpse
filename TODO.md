# TODO

- export/import corpus support


Let me help explain some common approaches for reducing the dimensionality and storage requirements of TF-IDF vectors:

1. **Stop Word Removal**
   - Remove common words that don't carry significant meaning (e.g., "the", "and", "is")
   - This can significantly reduce the vocabulary size while maintaining semantic meaning

2. **Stemming/Lemmatization**
   - Reduce words to their root form (e.g., "running" → "run", "better" → "good")
   - This reduces the vocabulary size by combining different forms of the same word

3. **Minimum Document Frequency**
   - Remove terms that appear in very few documents (e.g., less than 2-3 documents)
   - This eliminates rare terms that are likely noise or typos

4. **Maximum Document Frequency**
   - Remove terms that appear in too many documents (e.g., more than 80-90% of documents)
   - These terms are likely too common to be discriminative

5. **Feature Selection Methods**
   - **Chi-square**: Select features with highest chi-square scores
   - **Mutual Information**: Keep features with highest mutual information scores
   - **Variance Threshold**: Remove features with low variance

6. **Dimensionality Reduction**
   - **Truncated SVD (LSA)**: Reduce to top k components
   - **PCA**: Project onto principal components
   - **t-SNE**: Non-linear dimensionality reduction
   - **UMAP**: Similar to t-SNE but often faster

7. **Hashing Trick**
   - Use a hash function to map terms to a fixed number of features
   - Reduces memory usage but can cause collisions
   - Good for streaming/online learning scenarios

8. **Pruning Low-Value Features**
   - Remove features with low TF-IDF scores
   - Can be done by setting a minimum threshold
   - Helps focus on the most important terms

9. **Subword Tokenization**
   - Break words into smaller units (e.g., BPE, WordPiece)
   - Reduces vocabulary size while maintaining meaning
   - Particularly useful for handling unknown words

10. **Quantization**
    - Reduce precision of TF-IDF scores (e.g., from float64 to float32 or int8)
    - Can significantly reduce memory usage with minimal impact on performance

The choice of which approaches to use depends on your specific requirements:
- If memory is the primary concern, consider hashing or quantization
- If accuracy is critical, focus on feature selection and dimensionality reduction
- If processing speed is important, consider stemming and stop word removal
- If handling unknown words is important, consider subword tokenization

You can also combine multiple approaches. For example, you might:
1. Remove stop words
2. Apply stemming
3. Remove low-frequency terms
4. Use truncated SVD to reduce to 100 dimensions
5. Quantize the resulting vectors to float32

This would give you a good balance of reduced dimensionality, memory usage, and maintained semantic meaning.
