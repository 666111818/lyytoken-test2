import { BigInt,log } from "@graphprotocol/graph-ts";
import {
  Approval as ApprovalEvent,
  OwnershipTransferred as OwnershipTransferredEvent,
  Transfer as TransferEvent,
  TransferWithFee as TransferWithFeeEvent,
  WhitelistUpdated as WhitelistUpdatedEvent
} from "../generated/MyToken/MyToken";
import {
  Approval,
  OwnershipTransferred,
  Transfer,
  TransferWithFee,
  WhitelistUpdated,
  FeeSummary
} from "../generated/schema";

export function handleApproval(event: ApprovalEvent): void {
  
  let approvalEntity = new Approval(
    event.transaction.hash.toHex() + "-" + event.logIndex.toString()
  );

  approvalEntity.owner = event.params.owner;
  approvalEntity.spender = event.params.spender;
  approvalEntity.value = event.params.value;
  approvalEntity.blockNumber = event.block.number;
  approvalEntity.blockTimestamp = event.block.timestamp;
  approvalEntity.transactionHash = event.transaction.hash;

  approvalEntity.save();
}

export function handleOwnershipTransferred(event: OwnershipTransferredEvent): void {
  
  let ownershipEntity = new OwnershipTransferred(
    event.transaction.hash.toHex() + "-" + event.logIndex.toString()
  );

  ownershipEntity.previousOwner = event.params.previousOwner;
  ownershipEntity.newOwner = event.params.newOwner;
  ownershipEntity.blockNumber = event.block.number;
  ownershipEntity.blockTimestamp = event.block.timestamp;
  ownershipEntity.transactionHash = event.transaction.hash;

  ownershipEntity.save();
}

export function handleTransfer(event: TransferEvent): void {
    log.info("Handling Transfer event from {} to {} of value {}", [
        event.params.from.toHex(),
        event.params.to.toHex(),
        event.params.value.toString(),
    ]);
  
    let transferEntity = new Transfer(
        event.transaction.hash.toHex() + "-" + event.logIndex.toString()
    );

    transferEntity.from = event.params.from;
    transferEntity.to = event.params.to;
    transferEntity.value = event.params.value;
    transferEntity.blockNumber = event.block.number;
    transferEntity.blockTimestamp = event.block.timestamp;
    transferEntity.transactionHash = event.transaction.hash;

    transferEntity.save();

   
    let minute = event.block.timestamp.div(BigInt.fromI32(60));
    let feeSummaryId = minute.toString();

    let feeSummary = FeeSummary.load(feeSummaryId);
    if (!feeSummary) {
        feeSummary = new FeeSummary(feeSummaryId);
        feeSummary.minute = minute;
        feeSummary.totalTransfers = BigInt.fromI32(0);
        feeSummary.totalFees = BigInt.fromI32(0);
    }

    feeSummary.totalTransfers = feeSummary.totalTransfers.plus(BigInt.fromI32(1));
    feeSummary.save();
}


export function handleTransferWithFee(event: TransferWithFeeEvent): void {
  
  let transferEntity = new TransferWithFee(
    event.transaction.hash.toHex() + "-" + event.logIndex.toString()
  );

  transferEntity.from = event.params.from;
  transferEntity.to = event.params.to;
  transferEntity.amount = event.params.amount;
  transferEntity.fee = event.params.fee;
  transferEntity.timestamp = event.block.timestamp; 

  transferEntity.blockNumber = event.block.number;
  transferEntity.blockTimestamp = event.block.timestamp;
  transferEntity.transactionHash = event.transaction.hash;

  transferEntity.save();

  
  let minute = event.block.timestamp.div(BigInt.fromI32(60));
  let feeSummaryId = minute.toString();

  let feeSummary = FeeSummary.load(feeSummaryId);
  if (!feeSummary) {
    feeSummary = new FeeSummary(feeSummaryId);
    feeSummary.minute = minute;
    feeSummary.totalTransfers = BigInt.fromI32(0);
    feeSummary.totalFees = BigInt.fromI32(0);
  }

  feeSummary.totalTransfers = feeSummary.totalTransfers.plus(BigInt.fromI32(1));
  feeSummary.totalFees = feeSummary.totalFees.plus(event.params.fee);

  feeSummary.save();
}

export function handleWhitelistUpdated(event: WhitelistUpdatedEvent): void {
  
  let whitelistEntity = new WhitelistUpdated(
    event.transaction.hash.toHex() + "-" + event.logIndex.toString()
  );

  whitelistEntity.user = event.params.user;
  whitelistEntity.isWhitelisted = event.params.isWhitelisted;
  whitelistEntity.blockNumber = event.block.number;
  whitelistEntity.blockTimestamp = event.block.timestamp;
  whitelistEntity.transactionHash = event.transaction.hash;

  whitelistEntity.save();
}