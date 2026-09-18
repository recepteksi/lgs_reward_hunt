/// Where a reward in the shop stands for the child looking at it.
///
/// [available] can be asked for now. [locked] costs more than the balance —
/// shown, never hidden, with how far there is to go. [pending] has been asked
/// for and is waiting on a parent; it cannot be asked for again until they
/// answer. `RewardShopReadModel.stateOf` is the one place this is decided.
enum RewardOfferStateEnum { available, locked, pending }
