-- +goose Up

-- create the function with Src/DstAddr params, to resolve unknown FlowDirections in the future
CREATE FUNCTION isIncomingFlow AS(FlowDirection, SrcAddr, DstAddr) ->
    FlowDirection == 0;

-- +goose Down

DROP FUNCTION isIncomingFlow;
