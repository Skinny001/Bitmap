// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ByteBitmapStorage {
    // Single uint256 to store 32 bytes (8 bits each)
    uint256 private bitmap;

    // Store a byte (0-255) in a specific slot (0-31)
    function storeByteInSlot(uint8 slot, uint8 value) public {
        
        require(slot < 32, "Slot must be between 0 and 31");
        
        // Calculate bit position for the slot
        uint256 position = slot * 8;
        
        // Create a mask to clear the existing byte in that slot
        uint256 clearMask = ~(uint256(0xFF) << position);
        
        // Clear the existing byte in that slot
        bitmap = bitmap & clearMask;
        
        // Set the new byte value in that slot
        bitmap = bitmap | (uint256(value) << position);
    }
    
    // Return the value stored in a specific slot (0-31)
    function getByteFromSlot(uint8 slot) public view returns (uint8) {
        
        require(slot < 32, "Slot must be between 0 and 31");
        
        // Calculate bit position for the slot
        uint256 position = slot * 8;
        
        // Extract and return the byte value from that slot
        return uint8((bitmap >> position) & 0xFF);
    }
    
    // Return all values from all slots as a single uint256
    function getAllValues() public view returns (uint256) {
        return bitmap;
    }
    
    // Return all values as an array of bytes
    function getAllValuesAsArray() public view returns (uint8[32] memory) {
        uint8[32] memory values;
        
        for (uint8 i = 0; i < 32; i++) {
            values[i] = getByteFromSlot(i);
        }
        
        return values;
    }
}