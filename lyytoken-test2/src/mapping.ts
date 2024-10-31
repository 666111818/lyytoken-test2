import { BigInt, ByteArray, Bytes, crypto } from "@graphprotocol/graph-ts";
import {
  TransferWithFee as TransferWithFeeEvent,
} from "../generated/MyToken/MyToken";
import { TransferWithFee, MinuteSummary } from "../generated/schema";

export function handleTransferWithFee(event: TransferWithFeeEvent): void {
  
  let idString = event.transaction.hash.toHex() + "-" + event.logIndex.toString();
  let idBytes = Bytes.fromByteArray(crypto.keccak256(ByteArray.fromUTF8(idString)));
  
  let transferWithFee = new TransferWithFee(idString);
  transferWithFee.from = event.params.from;
  transferWithFee.to = event.params.to;
  transferWithFee.value = event.params.value;
  transferWithFee.feeAmount = event.params.feeAmount;
  transferWithFee.blockNumber = event.block.number;
  transferWithFee.blockTimestamp = event.block.timestamp;
  transferWithFee.transactionHash = event.transaction.hash;
  transferWithFee.save();

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
