// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<2x7xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      stablehlo.return %arg1 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2xi32>, tensor<2x7xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<2x7xui16>) {
    %0 = stablehlo.constant dense<"0x010001000600030001000400000003000100030001000300030000000200050002000000030001000200030002000100000000000100010005000100060000000000040000000100020003000100000000000400050002000000000000000500000000000100030001000000000001000100070001000100000001000200020000000000050004000800000000000300040002000600010000000000040001000300000001000000000001000100000000000000000002000000010003000200010003000300010003000000020004000200070004000100040005000000020000000300020001000100030002000100040003000600010001000200040001000000010000000300000002000200030000000700010000000200040001000300020000000100040003000200030000000400030003000300000004000000000003000300000001000300040000000100030002000200020004000600000000000700060000000200040000000100000000000000010000000100000003000200000004000000010001000300020001000200000000000300030003000100000001000000"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<[[1, 3, 0, 3, 3, 2, 1], [3, 1, 3, 0, 0, 3, 0]]> : tensor<2x7xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<2x7xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x010001000600030001000400000001000300000003000300020001000200050002000000030001000200030002000100000000000100010005000100060000000000040000000100020003000100000000000400050002000000000000000500000000000100030001000000000001000100070001000100000001000200020000000000050004000800000000000300040002000600010000000000040001000300000001000000000001000100000000000000000002000000010003000200010003000300010003000000020004000200030001000300000000000300000000000300020001000100030002000100040003000600010001000200040001000000010000000300000002000200030000000700010000000200040001000300020000000100040003000200030000000400030003000300000004000000000003000300000001000300040000000100030002000200020004000600000000000700060000000200040000000100000000000000010000000100000003000200000004000000010001000300020001000200000000000300030003000100000001000000"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}
