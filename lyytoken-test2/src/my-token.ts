import {
  Approval as ApprovalEvent,
  OwnershipTransferred as OwnershipTransferredEvent,
  Transfer as TransferEvent,
  TransferWithFee as TransferWithFeeEvent
} from "../generated/MyToken/MyToken";
import {
  Approval,
  OwnershipTransferred,
  Transfer,
  TransferWithFee,
  MinuteSummary
} from "../generated/schema";
import { BigInt } from "@graphprotocol/graph-ts";


export function handleApproval(event: ApprovalEvent): void {
  let id = event.transaction.hash.toHex() + "-" + event.logIndex.toString();
  let entity = new Approval(id);

  entity.owner = event.params.owner;
  entity.spender = event.params.spender;
  entity.value = event.params.value;
  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}


export function handleOwnershipTransferred(event: OwnershipTransferredEvent): void {
  let id = event.transaction.hash.toHex() + "-" + event.logIndex.toString();
  let entity = new OwnershipTransferred(id);

  entity.previousOwner = event.params.previousOwner;
  entity.newOwner = event.params.newOwner;
  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}


export function handleTransfer(event: TransferEvent): void {
  let id = event.transaction.hash.toHex() + "-" + event.logIndex.toString();
  let entity = new Transfer(id);

  entity.from = event.params.from;
  entity.to = event.params.to;
  entity.value = event.params.value;
  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}


export function handleTransferWithFee(event: TransferWithFeeEvent): void {
  let id = event.transaction.hash.toHex() + "-" + event.logIndex.toString();
  let entity = new TransferWithFee(id);

  entity.from = event.params.from;
  entity.to = event.params.to;
  entity.value = event.params.value;
  entity.feeAmount = event.params.feeAmount;
  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();


  let minuteTimestamp = event.block.timestamp.toI32() / 60;
  let minuteId = minuteTimestamp.toString();

  let minuteSummary = MinuteSummary.load(minuteId);
  if (minuteSummary == null) {
    minuteSummary = new MinuteSummary(minuteId);
    minuteSummary.minute = BigInt.fromI32(minuteTimestamp);
    minuteSummary.totalTransfers = BigInt.fromI32(0);
    minuteSummary.totalFees = BigInt.fromI32(0);
  }

  minuteSummary.totalTransfers = minuteSummary.totalTransfers.plus(BigInt.fromI32(1));
  minuteSummary.totalFees = minuteSummary.totalFees.plus(event.params.feeAmount);

  minuteSummary.save();
}
