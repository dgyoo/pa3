% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
function bid2tlbr_ = scaleBoxes( bid2tlbr, bid2rs, bid2cs )
    bid2rs = bid2rs( : )';
    bid2cs = bid2cs( : )';
    bid2center = [ bid2tlbr( 3, : ) + bid2tlbr( 1, : ); bid2tlbr( 4, : ) + bid2tlbr( 2, : ); ] / 2;
    bid2hnr = ( bid2tlbr( 3, : ) - bid2tlbr( 1, : ) ) .* bid2rs / 2;
    bid2hnc = ( bid2tlbr( 4, : ) - bid2tlbr( 2, : ) ) .* bid2cs / 2;
    bid2tlbr_ = repmat( bid2center, 2, 1 );
    bid2tlbr_ = bid2tlbr_ + [ -bid2hnr; -bid2hnc; bid2hnr; bid2hnc; ];
end