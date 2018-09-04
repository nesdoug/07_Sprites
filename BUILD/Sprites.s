;
; File generated by cc65 v 2.15
;
	.fopt		compiler,"cc65 v 2.15"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_pal_bg
	.import		_pal_spr
	.import		_ppu_wait_nmi
	.import		_ppu_off
	.import		_ppu_on_all
	.import		_oam_clear
	.import		_oam_spr
	.import		_oam_meta_spr
	.import		_bank_spr
	.import		_vram_adr
	.import		_vram_write
	.export		_metasprite
	.export		_metasprite2
	.export		_y_position
	.export		_x_position
	.export		_x_position2
	.export		_x_position3
	.export		_sprid
	.export		_text
	.export		_palette_bg
	.export		_palette_sp
	.export		_main

.segment	"DATA"

_y_position:
	.byte	$40
_x_position:
	.byte	$88
_x_position2:
	.byte	$A0
_x_position3:
	.byte	$C0

.segment	"RODATA"

_metasprite:
	.byte	$00
	.byte	$00
	.byte	$01
	.byte	$00
	.byte	$00
	.byte	$08
	.byte	$11
	.byte	$00
	.byte	$08
	.byte	$00
	.byte	$01
	.byte	$40
	.byte	$08
	.byte	$08
	.byte	$11
	.byte	$40
	.byte	$80
_metasprite2:
	.byte	$08
	.byte	$00
	.byte	$03
	.byte	$00
	.byte	$00
	.byte	$08
	.byte	$12
	.byte	$00
	.byte	$08
	.byte	$08
	.byte	$13
	.byte	$00
	.byte	$10
	.byte	$08
	.byte	$12
	.byte	$40
	.byte	$00
	.byte	$10
	.byte	$22
	.byte	$00
	.byte	$08
	.byte	$10
	.byte	$23
	.byte	$00
	.byte	$10
	.byte	$10
	.byte	$22
	.byte	$40
	.byte	$80
_text:
	.byte	$53,$70,$72,$69,$74,$65,$73,$00
_palette_bg:
	.byte	$0F
	.byte	$00
	.byte	$10
	.byte	$30
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
_palette_sp:
	.byte	$0F
	.byte	$0F
	.byte	$0F
	.byte	$28
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00

.segment	"BSS"

.segment	"ZEROPAGE"
_sprid:
	.res	1,$00

; ---------------------------------------------------------------
; void __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

;
; ppu_off(); // screen off
;
	jsr     _ppu_off
;
; pal_bg(palette_bg);
;
	lda     #<(_palette_bg)
	ldx     #>(_palette_bg)
	jsr     _pal_bg
;
; pal_spr(palette_sp);
;
	lda     #<(_palette_sp)
	ldx     #>(_palette_sp)
	jsr     _pal_spr
;
; bank_spr(1);
;
	lda     #$01
	jsr     _bank_spr
;
; vram_adr(NTADR_A(7,14)); // set a start position for the text
;
	ldx     #$21
	lda     #$C7
	jsr     _vram_adr
;
; vram_write(text,sizeof(text));
;
	lda     #<(_text)
	ldx     #>(_text)
	jsr     pushax
	ldx     #$00
	lda     #$08
	jsr     _vram_write
;
; ppu_on_all(); // turn on screen
;
	jsr     _ppu_on_all
;
; ppu_wait_nmi(); // wait till beginning of the frame
;
L0069:	jsr     _ppu_wait_nmi
;
; oam_clear();
;
	jsr     _oam_clear
;
; sprid = 0;
;
	lda     #$00
	sta     _sprid
;
; sprid = oam_spr(x_position, y_position, 0, 0, sprid);
;
	jsr     decsp4
	lda     _x_position
	ldy     #$03
	sta     (sp),y
	lda     _y_position
	dey
	sta     (sp),y
	lda     #$00
	dey
	sta     (sp),y
	dey
	sta     (sp),y
	lda     _sprid
	jsr     _oam_spr
	sta     _sprid
;
; sprid = oam_meta_spr(x_position2, y_position, sprid, metasprite);
;
	jsr     decsp3
	lda     _x_position2
	ldy     #$02
	sta     (sp),y
	lda     _y_position
	dey
	sta     (sp),y
	lda     _sprid
	dey
	sta     (sp),y
	lda     #<(_metasprite)
	ldx     #>(_metasprite)
	jsr     _oam_meta_spr
	sta     _sprid
;
; sprid = oam_meta_spr(x_position3, y_position, sprid, metasprite2);
;
	jsr     decsp3
	lda     _x_position3
	ldy     #$02
	sta     (sp),y
	lda     _y_position
	dey
	sta     (sp),y
	lda     _sprid
	dey
	sta     (sp),y
	lda     #<(_metasprite2)
	ldx     #>(_metasprite2)
	jsr     _oam_meta_spr
	sta     _sprid
;
; ++y_position; // every frame, shift them down 1 pixel
;
	inc     _y_position
;
; while (1){
;
	jmp     L0069

.endproc

