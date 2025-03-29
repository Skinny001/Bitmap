// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/ByteBitmapStorage.sol";

contract ByteBitmapStorageTest is Test {
    ByteBitmapStorage public bitmapStorage;
    
    function setUp() public {
        bitmapStorage = new ByteBitmapStorage();
    }
    
    function testStoreAndRetrieveSingleValue() public {
        uint8 slot = 5;
        uint8 value = 123;
        
        bitmapStorage.storeByteInSlot(slot, value);
        uint8 retrievedValue = bitmapStorage.getByteFromSlot(slot);
        
        assertEq(retrievedValue, value, "Retrieved value should match stored value");
    }
    
    function testStoreAndRetrieveMultipleValues() public {
        // Store values in various slots
        bitmapStorage.storeByteInSlot(0, 100);
        bitmapStorage.storeByteInSlot(10, 150);
        bitmapStorage.storeByteInSlot(31, 255);
        
        // Verify individual retrieval
        assertEq(bitmapStorage.getByteFromSlot(0), 100, "Slot 0 should contain 100");
        assertEq(bitmapStorage.getByteFromSlot(10), 150, "Slot 10 should contain 150");
        assertEq(bitmapStorage.getByteFromSlot(31), 255, "Slot 31 should contain 255");
        
        // Verify empty slots are zero
        assertEq(bitmapStorage.getByteFromSlot(5), 0, "Slot 5 should be empty (0)");
    }
    
    function testGetAllValues() public {
        // Store values in various slots
        bitmapStorage.storeByteInSlot(0, 10);
        bitmapStorage.storeByteInSlot(1, 20);
        bitmapStorage.storeByteInSlot(31, 30);
        
        // Get all values as bitmap
        uint256 allValues = bitmapStorage.getAllValues();
        
        // Check if the retrieved bitmap has the correct values at the expected bit positions
        assertEq(allValues & 0xFF, 10, "Lowest byte should be 10");
        assertEq((allValues >> 8) & 0xFF, 20, "Second byte should be 20");
        assertEq((allValues >> 248) & 0xFF, 30, "Highest byte should be 30");
    }
    
    function testGetAllValuesAsArray() public {
        // Store values in various slots
        bitmapStorage.storeByteInSlot(2, 42);
        bitmapStorage.storeByteInSlot(15, 127);
        
        // Get all values as array
        uint8[32] memory values = bitmapStorage.getAllValuesAsArray();
        
        // Verify values at specific indices
        assertEq(values[2], 42, "Array index 2 should contain 42");
        assertEq(values[15], 127, "Array index 15 should contain 127");
        assertEq(values[0], 0, "Array index 0 should be empty (0)");
    }
    
    function testSlotOutOfBounds() public {
        // This should revert with the message "Slot must be between 0 and 31"
        vm.expectRevert("Slot must be between 0 and 31");
        bitmapStorage.storeByteInSlot(32, 100);
        
        vm.expectRevert("Slot must be between 0 and 31");
        bitmapStorage.getByteFromSlot(32);
    }
    
    function testOverwriteValue() public {
        uint8 slot = 7;
        
        // Store initial value
        bitmapStorage.storeByteInSlot(slot, 50);
        assertEq(bitmapStorage.getByteFromSlot(slot), 50, "Initial value should be 50");
        
        // Overwrite with new value
        bitmapStorage.storeByteInSlot(slot, 75);
        assertEq(bitmapStorage.getByteFromSlot(slot), 75, "Value should be updated to 75");
    }
}