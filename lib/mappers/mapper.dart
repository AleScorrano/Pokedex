abstract class DTOMapper<D, M> {
  M toModel(D dto);

  Map<String, dynamic> toTransferObject(M model);
}
