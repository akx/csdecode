# distutils: language=c++
# cython: language_level=3

cdef extern from "JUCE/modules/juce_core/juce_core.h":
    pass

cdef extern from "juce_hack.cpp":
    pass

cdef extern from "JUCE/modules/juce_cryptography/encryption/juce_BlowFish.h" namespace "juce":
    cdef cppclass BlowFish:
        BlowFish(const void*, int)
        int encrypt(void*, size_t, size_t)
        int decrypt(void*, size_t)

cdef extern from "JUCE/modules/juce_core/memory/juce_MemoryBlock.cpp" namespace "juce":
    cdef cppclass MemoryBlock:
        MemoryBlock()
        int fromBase64Encoding(StringRef s)
        String toBase64Encoding()
        void* getData()
        size_t getSize()
        void copyTo (void* destData, int sourceOffset, size_t numBytes)


cdef extern from "JUCE/modules/juce_core/text/juce_String.cpp" namespace "juce":
    cdef cppclass StringRef:
        StringRef ()
        StringRef (const char* stringLiteral)
    cdef cppclass String:
        pass


cdef extern from "JUCE/modules/juce_core/text/juce_CharacterFunctions.cpp" namespace "juce":
    pass

cdef extern from "JUCE/modules/juce_cryptography/encryption/juce_BlowFish.cpp" namespace "juce":
    pass


def decrypt_blowfish(bytes key, bytes buffer):
    cdef const unsigned char[:] key_buffer = key
    cdef unsigned char[:] data_buffer = bytearray(buffer[:])
    bf = new BlowFish(<char*>&key_buffer[0], len(key))
    x = bf.decrypt(<char*>&data_buffer[0], len(buffer))
    return (x, bytes(data_buffer))


def encrypt_blowfish(bytes key, bytes buffer):
    cdef const unsigned char[:] key_buffer = key
    cdef unsigned char[:] data_buffer = bytearray(buffer[:] + bytes(64))
    bf = new BlowFish(<char*>&key_buffer[0], len(key))
    x = bf.encrypt(<char*>&data_buffer[0], len(buffer), len(data_buffer))
    return (x, bytes(data_buffer))


def decode_juce_base64(bytes original):
    cdef MemoryBlock* mb = new MemoryBlock()
    cdef StringRef sref = StringRef(original)
    mb.fromBase64Encoding(sref)
    cdef char* decoded = <char*>mb.getData()
    return decoded[:mb.getSize()]
