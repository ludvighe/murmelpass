enum HLState {
  HASH_LENGTH_16,
  HASH_LENGTH_32,
  HASH_LENGTH_64,
  HASH_LENGTH_128,
  HASH_LENGTH_256
}

class HashLength {
  HashLength(this.state);
  final HLState state;

  factory HashLength.fromInt(int value) {
    switch (value) {
      case 16:
        return HashLength(HLState.HASH_LENGTH_16);
        break;
      case 32:
        return HashLength(HLState.HASH_LENGTH_32);
        break;
      case 64:
        return HashLength(HLState.HASH_LENGTH_64);
        break;
      case 128:
        return HashLength(HLState.HASH_LENGTH_128);
        break;
      case 256:
        return HashLength(HLState.HASH_LENGTH_256);
        break;
      default:
        throw Exception('Failed to parse int --> HLState: Invalid value.');
    }
  }

  int toInt() {
    switch (state) {
      case HLState.HASH_LENGTH_16:
        return 16;
        break;
      case HLState.HASH_LENGTH_32:
        return 32;
        break;
      case HLState.HASH_LENGTH_64:
        return 64;
        break;
      case HLState.HASH_LENGTH_128:
        return 128;
        break;
      case HLState.HASH_LENGTH_256:
        return 256;
        break;
      default:
        throw Exception('Failed to parse HLState --> int (length).');
    }
  }

  // Converts enum HashLength to matching output bits to get inquired length
  int sha3OutputBits() {
    switch (state) {
      case HLState.HASH_LENGTH_16:
        return 64;
        break;
      case HLState.HASH_LENGTH_32:
        return 128;
        break;
      case HLState.HASH_LENGTH_64:
        return 256;
        break;
      case HLState.HASH_LENGTH_128:
        return 512;
        break;
      case HLState.HASH_LENGTH_256:
        return 1024;
        break;
      default:
        throw Exception('Failed to parse HLState --> int (output bits).');
    }
  }
}
