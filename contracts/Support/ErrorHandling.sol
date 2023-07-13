// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

library ErrorHandling {
    error CallerNotOwnerNorApproved();
    error InsufficientPayment();
    error InvalidTokenId();
}