# Image-Steganography
. In this project steganography are based on Block-DCT and Huffman coding, where DCT is used to transform original image (cover image) blocks from spatial domain to frequency domain and Huffman coding is done to convert messages into bits of 0’s and 1’s. Huffman encoding is performed on the secret messages before embedding and each bit of Huffman code of secret message is embedded in the frequency domain by altering the least significant bit of each of the DCT coefficients of cover image blocks. High level security is maintained since the secret message cannot be extracted without knowing decoding rules and Huffman table.