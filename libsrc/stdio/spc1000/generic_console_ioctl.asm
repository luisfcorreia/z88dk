
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	__spc1000_mode
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32


; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;bc = where we point to
	inc	hl
	ld	b,(hl)
        cp      IOCTL_GENCON_SET_FONT32
        jr      nz,check_set_udg
        ld      (generic_console_font32),bc
success:
        and     a
        ret
check_set_udg:
        cp      IOCTL_GENCON_SET_UDGS
        jr      nz,check_mode
        ld      (generic_console_udg32),bc
        jr      success
check_mode:
	cp	IOCTL_GENCON_SET_MODE
	jr	nz,failure
	ld	a,c		; The mode
	ld	h,@00000000
	ld	l,16
	and	a
	jr	z,set_mode
	ld	h,0x8e
	ld	l,24
	cp	1		;HIRES
	jr	z,set_mode
	cp	10		;Switch to VDP
	jr	nz,failure
	ld	(__spc1000_mode),a
	ld	a,24
	ld	(__console_h),a
	call	generic_console_cls
	jr	success

set_mode:
	ld	(__spc1000_mode),a
	ld	bc,$2000
	out	(c),h
	ld	a,l
	ld	(__console_h),a
	call	generic_console_cls
	and	a
	ret
failure:
	scf
	ret