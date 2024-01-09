#include <iostream>
#include <fstream>
#include <memory>
#include <vector>

class Bitmap {
public:

	Bitmap()
		: signature(0), fileSize(0), reservedHeader(0), dataOffset(0), 
		size(0), width(0), height(0), planes(0), bpp(0), compression(0),
		imageSize(0), xppm(0), yppm(0), coloursUsed(0), importantColours(0),
		numColours(0)
	{
	}

	Bitmap(const Bitmap& obj) = default;
	~Bitmap() = default;
	Bitmap(Bitmap&& obj) = delete;
	Bitmap& operator=(const Bitmap& obj) = delete;
	Bitmap& operator=(Bitmap&& obj) = delete;
	
	bool operator==(const Bitmap& other) const = delete;

	void load(const char* filename) {
		std::ifstream fs(filename, std::ios::binary);
		if (!fs) {
			throw "Cannot open file.";
		}
		Bitmap bitmap;
		char header[14];
		fs.read(header, 14);
		if (header[0] != 'B' && header[1] != 'M') {
			throw "Not a valid BMP file.";
		}

		std::memcpy(&signature, &header[0], 2);
		std::memcpy(&fileSize, &header[2], 4);
		std::memcpy(&reservedHeader, &header[6], 4);
		std::memcpy(&dataOffset, &header[10], 4);

		auto body = std::make_unique<char[]>(fileSize - 14);
		fs.read(body.get(), fileSize - 14);
		std::memcpy(&size, &body[0], 4);
		std::memcpy(&width, &body[4], 4);
		std::memcpy(&height, &body[8], 4);
		std::memcpy(&planes, &body[12], 2);
		std::memcpy(&bpp, &body[14], 2);
		if (bpp == 4) {
			numColours = 16;
		}
		else {
			throw "Not a valid Mega Drive pallet - must be 4 bpp = 16 colours.";
		}

		std::memcpy(&compression, &body[16], 4);
		if (compression != 0) {
			throw "Requires uncompressed BMP.";
		}
		std::memcpy(&imageSize, &body[20], 4);
		std::memcpy(&xppm, &body[24], 4);
		std::memcpy(&yppm, &body[28], 4);
		std::memcpy(&coloursUsed, &body[32], 4);
		std::memcpy(&importantColours, &body[36], 4);

		for (int i = 0; i < 4 * numColours; i += 4) {
			ColourTable table{};
			std::memcpy(&table.blue, &body[40 + i], 1);
			std::memcpy(&table.green, &body[41 + i], 1);
			std::memcpy(&table.red, &body[42 + i], 1);
			std::memcpy(&table.reserved, &body[43 + i], 1);

			colourTable.push_back(table);
		}

		int dataIndex = 40 + 4 * numColours;
		int numPixels = fileSize - dataIndex - 14;
		//std::cout << "dataIndex " << dataIndex << std::endl;
		//std::cout << "numPixels " << numPixels << std::endl;
		pixels.resize(numPixels);

		std::memcpy(pixels.data(), &body[dataIndex], numPixels);
		flip();
	}

	void print() {
		printHeaderAndBody(); 
		printColourTable(); 
		printPixels(); 
		printGrid(true);
	}

private:

	void flip() {
		pixelsFlipped.resize(pixels.size());
		for (unsigned j = 1; j <= height; ++j) {
			for (unsigned i = 0; i < width / 2; ++i) {
				pixelsFlipped[i + (j - 1) * (width / 2)] = pixels[i + (width - j) * (width / 2)];
			}
		}
	}
	
	void printHeaderAndBody() {
		std::cout << "signature " << signature << std::endl;
		std::cout << "fileSize " << fileSize << std::endl;
		std::cout << "reservedHeader " << reservedHeader << std::endl;
		std::cout << "dataOffset " << dataOffset << std::endl;

		std::cout << "size " << size << std::endl;
		std::cout << "width " << width << std::endl;
		std::cout << "height " << height << std::endl;
		std::cout << "planes " << planes << std::endl;
		std::cout << "bpp " << bpp << std::endl;
		std::cout << "compression " << compression << std::endl;
		std::cout << "imageSize " << imageSize << std::endl;
		std::cout << "xppm " << xppm << std::endl;
		std::cout << "yppm " << yppm << std::endl;
		std::cout << "coloursUsed " << coloursUsed << std::endl;
		std::cout << "importantColours " << importantColours << std::endl;
	}

	void printColourTable() {
		int i = 0;
		for (auto& table : colourTable) {
			std::cout << "table " << i++
				<< " : blue " << (int)table.blue
				<< ", green " << (int)table.green
				<< ", red " << (int)table.red
				<< ", reserved " << (int)table.reserved << std::endl;
		}
	}

	void printPixels(bool flipped = false) {
		const auto& data = flipped ? pixelsFlipped : pixels;
		std::cout << std::string{flipped ? "pixels flipped: " : "pixels BMP order: "} << std::endl;
		for (int i = 0; i < data.size(); ++i) {
			std::cout << std::hex << (int)data[i] << " ";
		}
		std::cout << std::endl;
	}

	void printGrid(bool flipped = false) {
		const auto& data = flipped ? pixelsFlipped : pixels;
		std::cout << std::string{flipped ? "pixels flipped: " : "pixels BMP order: "} << std::endl;
		for (unsigned j = 0; j < height; ++j) {
			for (unsigned i = 0; i < width / 2; ++i) {
				std::cout << (int)data[i + j * (width / 2)] << " ";
			}
			std::cout << std::endl;
		}
	}

	unsigned short signature;
	unsigned fileSize;
	unsigned reservedHeader;
	unsigned dataOffset;
	
	unsigned size;
	unsigned width;
	unsigned height;
	unsigned short planes;
	unsigned short bpp;
	unsigned compression;
	unsigned imageSize;
	unsigned xppm;
	unsigned yppm;
	unsigned coloursUsed;
	unsigned importantColours;

	unsigned char numColours;
	struct ColourTable {
		unsigned char blue;
		unsigned char green;
		unsigned char red;
		unsigned char reserved;
	};
	std::vector<ColourTable> colourTable;
	
	std::vector<unsigned char> pixels; // each char is 2 pixels
	std::vector<unsigned char> pixelsFlipped;
};

int main(int argc, int **argv) {
	Bitmap bitmap;
	bitmap.load("img/image.bmp");
	bitmap.print();
}
