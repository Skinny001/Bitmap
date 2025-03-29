# ByteBitmapStorage: Efficient On-Chain Data Storage

## Overview

ByteBitmapStorage is a gas-efficient Solidity smart contract that demonstrates the power of bitmap storage by using a single `uint256` to store 32 separate byte values. This approach significantly reduces gas costs compared to traditional array storage, making it ideal for applications that need to store multiple small values on-chain.

## Key Features

- **Efficient Storage**: Uses a single `uint256` to store 32 bytes (0-255 values)
- **Slot-Based Access**: Access any of the 32 slots independently
- **Full Value Retrieval**: Get all values at once or access individual slots
- **Gas Optimization**: Minimizes storage costs through bit manipulation

## How It Works

The contract uses bit manipulation techniques to:
1. Store bytes at specific positions in a 256-bit integer
2. Retrieve individual bytes from their positions
3. Work with the entire bitmap as needed

Each slot can store a value from 0 to 255 (a single byte), and the contract provides intuitive functions to interact with these values.

## Contract Functions

### `storeByteInSlot(uint8 slot, uint8 value)`

Stores a byte value (0-255) in a specific slot (0-31).

```solidity
// Example: Store value 123 in slot 5
contract.storeByteInSlot(5, 123);
```

### `getByteFromSlot(uint8 slot)`

Retrieves the byte value stored in a specific slot.

```solidity
// Example: Get the value from slot 5
uint8 value = contract.getByteFromSlot(5);  // Returns 123
```

### `getAllValues()`

Returns the entire bitmap as a single `uint256`.

```solidity
// Example: Get the entire bitmap
uint256 bitmap = contract.getAllValues();
```

### `getAllValuesAsArray()`

Returns all 32 values as a fixed-size array of bytes.

```solidity
// Example: Get all values as an array
uint8[32] memory values = contract.getAllValuesAsArray();
```

## Technical Details

### Bit Manipulation Explained

The contract uses several bit manipulation techniques:

1. **Slot to Bit Position Calculation**: `position = slot * 8`
   - Each byte occupies 8 bits in the 256-bit integer

2. **Clearing a Byte**: `bitmap & ~(0xFF << position)`
   - Creates a mask with zeros only at the target byte position
   - ANDing with this mask clears the existing byte

3. **Setting a Byte**: `bitmap | (value << position)`
   - Shifts the value to the correct position
   - ORing with the bitmap places the value in the cleared slot

4. **Extracting a Byte**: `(bitmap >> position) & 0xFF`
   - Shifts the target byte to the rightmost position
   - ANDing with 0xFF isolates just the byte we want

## Use Cases

This contract is ideal for:

- Storing flags, states, or small counters for multiple entities
- Managing permission bits for different roles
- Tracking small values where an array would be wasteful
- Any application that needs efficient storage of multiple small values

## Testing

The contract includes comprehensive tests that verify:

- Single value storage and retrieval
- Multiple value storage and retrieval
- Boundary value testing
- Error handling for out-of-bounds access
- Value overwriting functionality

Run the tests using Foundry:

```bash
forge test
```

## Gas Efficiency

Using bitmap storage can significantly reduce gas costs compared to array storage, especially when dealing with many small values. The exact savings will depend on your specific use case, but the difference can be substantial when working with multiple transactions.
