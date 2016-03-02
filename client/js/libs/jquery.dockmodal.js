/*
 * jQuery.dockmodal - jQuery dockable modal dialog widget
 *
 * Copyright 2014, uxMine
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * Date: 2/11/2014
 * @author Tarafder Ashek E Elahi
 * @version 1.1
 * Depends:
 *   jquery.js
 *
 */

;
(function ($) {
    var defaults = {
        width: 750,
        height: "65%",
        minimizedWidth: 200,
        gutter: 10,
        poppedOutDistance: "6%",
        title: "",
        dialogClass: "",
        buttons: [], /* id, html, buttonClass, click */
        animationSpeed: 1000,
        opacity: 1,
        initialState: 'modal', /* "modal", "docked", "minimized" */

        showClose: true,
        showPopout: true,
        showMinimize: true,

        create: undefined,
        open: undefined,
        beforeClose: undefined,
        close: undefined,
        beforeMinimize: undefined,
        minimize: undefined,
        beforeRestore: undefined,
        restore: undefined,
        beforePopout: undefined,
        popout: undefined
    };
    var dClass = "dockmodal";
    var windowWidth = $(window).width();

    function setAnimationCSS($this, $el) {
        var aniSpeed = $this.options.animationSpeed / 1000;
        $el.css({"transition": aniSpeed + "s right, " + aniSpeed + "s left, " + aniSpeed + "s top, " + aniSpeed + "s height, " + aniSpeed + "s width"});
        return true;
    }

    function removeAnimationCSS($el) {
        $el.css({"transition": "none"});
        return true;
    }

    var methods = {
        init: function (options) {

            return this.each(function () {

                var $this = $(this);
                var data = $this.data('dockmodal');
                $this.options = $.extend({}, defaults, options);

                // If the plugin hasn't been initialized yet
                if (!data) {
                    $this.data('dockmodal', $this);
                } else {
                    $("body").append($this.closest("." + dClass).show());
                    //methods.restore.apply($this);
                    methods.refreshLayout();
                    setTimeout(function () {
                        methods.restore.apply($this);
                    }, $this.options.animationSpeed);
                    return;
                }

                // create modal
                var $body = $("body");
                var $window = $(window);
                var $dockModal = $('<div/>').addClass(dClass).addClass($this.options.dialogClass);
                if ($this.options.initialState == "modal") {
                    $dockModal.addClass("popped-out");
                } else if ($this.options.initialState == "minimized") {
                    $dockModal.addClass("minimized");
                }
                //$dockModal.width($this.options.width);
                $dockModal.height(0);
                setAnimationCSS($this, $dockModal);

                // create title
                var $dockHeader = $('<div></div>').addClass(dClass + "-header");
                if ($this.options.showClose) {
                    $('<a href="#" class="header-action action-close" title="Close"><i class="icon-remove icon-light"></i></a>').appendTo($dockHeader).click(function (e) {
                        methods.destroy.apply($this);
                        return false;
                    });
                }
                if ($this.options.showPopout) {
                    $('<a href="#" class="header-action action-popout" title="Pop out"><i class="icon-resize-full icon-light"></i></a>').appendTo($dockHeader).click(function (e) {
                        if ($dockModal.hasClass("popped-out")) {
                            methods.restore.apply($this);
                        } else {
                            methods.popout.apply($this);
                        }
                        return false;
                    });
                }
                if ($this.options.showMinimize) {
                    $('<a href="#" class="header-action action-minimize" title="Minimize"><i class="icon-minus icon-light"></i></a>').appendTo($dockHeader).click(function (e) {
                        if ($dockModal.hasClass("minimized")) {
                            if ($dockModal.hasClass("popped-out")) {
                                methods.popout.apply($this);
                            } else {
                                methods.restore.apply($this);
                            }
                        } else {
                            methods.minimize.apply($this);
                        }
                        return false;
                    });
                }
                if ($this.options.showMinimize && $this.options.showPopout) {
                    $dockHeader.click(function () {
                        if ($dockModal.hasClass("minimized")) {
                            if ($dockModal.hasClass("popped-out")) {
                                methods.popout.apply($this);
                            } else {
                                methods.restore.apply($this);
                            }
                        } else {
                            methods.minimize.apply($this);
                        }
                        return false;
                    });
                }
                $dockHeader.append('<div class="title-text">' + ($this.options.title || $this.attr("title")) + '</div>');
                $dockModal.append($dockHeader);

                // create body section
                var $placeholder = $('<div class="modal-placeholder"></div>').insertAfter($this);
                $this.placeholder = $placeholder;
                var $dockBody = $('<div></div>').addClass(dClass + "-body").append($this);
                $dockModal.append($dockBody);

                // create footer
                if ($this.options.buttons.length) {
                    var $dockFooter = $('<div></div>').addClass(dClass + "-footer");
                    var $dockFooterButtonset = $('<div></div>').addClass(dClass + "-footer-buttonset");
                    $dockFooter.append($dockFooterButtonset);
                    $.each($this.options.buttons, function (indx, el) {
                        var $btn = $('<a href="#" class="btn"></a>');
                        $btn.attr({ "id": el.id, "class": el.buttonClass });
                        $btn.html(el.html);
                        $btn.click(function (e) {
                            el.click(e, $this);
                            return false;
                        });
                        $dockFooterButtonset.append($btn);
                    });
                    $dockModal.append($dockFooter);
                } else {
                    $dockModal.addClass("no-footer");
                }

                // create overlay
                var $overlay = $("." + dClass + "-overlay");
                if (!$overlay.length) {
                    $overlay = $('<div/>').addClass(dClass + "-overlay");
                }

                // raise create event
                if ($.isFunction($this.options.create)) {
                    $this.options.create($this);
                }

                $body.append($dockModal);
                $dockModal.after($overlay);
                $dockBody.focus();

                // raise open event
                if ($.isFunction($this.options.open)) {
                    setTimeout(function () {
                        $this.options.open($this);
                    }, $this.options.animationSpeed);
                }

                //methods.restore.apply($this);
                if ($dockModal.hasClass("minimized")) {
                    $dockModal.find(".dockmodal-body, .dockmodal-footer").hide();
                    methods.minimize.apply($this);
                } else {
                    if ($dockModal.hasClass("popped-out")) {
                        methods.popout.apply($this);
                    } else {
                        methods.restore.apply($this);
                    }
                }

                // attach resize event
                // track width, set to window width
                $body.data("windowWidth", $window.width());

                $window.unbind("resize.dockmodal").bind("resize.dockmodal", function () {
                    // do nothing if the width is the same
                    // update new width value
                    if ($window.width() == $body.data("windowWidth")) {
                        return;
                    }

                    $body.data("windowWidth", $window.width());
                    methods.refreshLayout();
                });
            });
        },
        destroy: function () {
            return this.each(function () {

                var $this = $(this).data('dockmodal');
                if (!$this)
                    return;

                // raise beforeClose event
                if ($.isFunction($this.options.beforeClose)) {
                    if ($this.options.beforeClose($this) === false) {
                        return;
                    }
                }

                try {
                    var $dockModal = $this.closest("." + dClass);

                    if ($dockModal.hasClass("popped-out") && !$dockModal.hasClass("minimized")) {
                        $dockModal.css({
                            "left": "50%",
                            "right": "50%",
                            "top": "50%",
                            "bottom": "50%"
                        });
                    } else {
                        $dockModal.css({
                            "width": "0",
                            "height": "0"
                        });
                    }
                    setTimeout(function () {
                        $this.removeData('dockmodal');
                        $this.placeholder.replaceWith($this);
                        $dockModal.remove();
                        $("." + dClass + "-overlay").hide();
                        methods.refreshLayout();

                        // raise close event
                        if ($.isFunction($this.options.close)) {
                            $this.options.close($this);
                        }
                    }, $this.options.animationSpeed);

                }
                catch (err) {
                    alert(err.message);
                }
                // other destroy routines

            })
        },
        close: function () {
            methods.destroy.apply(this);
        },
        minimize: function () {
            return this.each(function () {

                var $this = $(this).data('dockmodal');
                if (!$this)
                    return;

                // raise beforeMinimize event
                if ($.isFunction($this.options.beforeMinimize)) {
                    if ($this.options.beforeMinimize($this) === false) {
                        return;
                    }
                }

                var $dockModal = $this.closest("." + dClass);
                var headerHeight = $dockModal.find(".dockmodal-header").outerHeight();
                $dockModal.addClass("minimized").css({
                    "width": $this.options.minimizedWidth + "px",
                    "height": headerHeight + "px",
                    "left": "auto",
                    "right": "auto",
                    "top": "auto",
                    "bottom": 42 + "px"
                });
                setTimeout(function () {
                    // for safty, hide the body and footer
                    $dockModal.find(".dockmodal-body, .dockmodal-footer").hide();

                    // raise minimize event
                    if ($.isFunction($this.options.minimize)) {
                        $this.options.minimize($this);
                    }
                }, $this.options.animationSpeed);

                $("." + dClass + "-overlay").hide();
                $dockModal.find(".action-minimize").attr("title", "Restore");

                methods.refreshLayout();
            })
        },
        restore: function () {
			$('ul.dropdown-menu').parent().removeClass('open');
            return this.each(function () {

                var $this = $(this).data('dockmodal');
                if (!$this)
                    return;

                // raise beforeRestore event
                if ($.isFunction($this.options.beforeRestore)) {
                    if ($this.options.beforeRestore($this) === false) {
                        return;
                    }
                }

                var $dockModal = $this.closest("." + dClass);
                $dockModal.removeClass("minimized popped-out");
                $dockModal.find(".dockmodal-body, .dockmodal-footer").show();
                $dockModal.css({
                    "width": $this.options.width + "px",
                    "height": $this.options.height,
                    "left": "auto",
                    "right": "auto",
                    "top": "auto",
                    "bottom": 42 + "px"
                });

                $("." + dClass + "-overlay").hide();
                $dockModal.find(".action-minimize").attr("title", "Minimize");
                $dockModal.find(".action-popout").attr("title", "Pop-out (ctrl+click)");

                setTimeout(function () {
                    // raise restore event
                    if ($.isFunction($this.options.restore)) {
                        $this.options.restore($this);
                    }
                }, $this.options.animationSpeed);

                methods.refreshLayout();
            })
        },
        popout: function () {
			$('ul.dropdown-menu').parent().removeClass('open');
            return this.each(function () {

                var $this = $(this).data('dockmodal');
                if (!$this)
                    return;

                // raise beforePopout event
                if ($.isFunction($this.options.beforePopout)) {
                    if ($this.options.beforePopout($this) === false) {
                        return;
                    }
                }

                var $dockModal = $this.closest("." + dClass);
                $dockModal.find(".dockmodal-body, .dockmodal-footer").show();

                // prepare element for animation
                removeAnimationCSS($dockModal);
                var offset = $dockModal.position();
                var windowWidth = $(window).width();
                $dockModal.css({
                    "width": "auto",
                    "height": "auto",
                    "left": offset.left + "px",
                    "right": (windowWidth - offset.left - $dockModal.outerWidth(true)) + "px",
                    "top": offset.top + "px",
                    "bottom": 42 + "px"
                });

                setAnimationCSS($this, $dockModal);
                setTimeout(function () {
                    $dockModal.removeClass("minimized").addClass("popped-out").css({
                        "width": "auto",
                        "height": "auto",
                        "left": $this.options.poppedOutDistance,
                        "right": $this.options.poppedOutDistance,
                        "top": $this.options.poppedOutDistance,
                        "bottom": 42 + "px"
                    });
                    $("." + dClass + "-overlay").show();
                    $dockModal.find(".action-popout").attr("title", "Pop-in");

                    methods.refreshLayout();
                }, 10);

                setTimeout(function () {
                    // raise popout event
                    if ($.isFunction($this.options.popout)) {
                        $this.options.popout($this);
                    }
                }, $this.options.animationSpeed);
            });
        },
        refreshLayout: function () {

            var right = 0;
            var windowWidth = $(window).width();

            $.each($("." + dClass).toArray().reverse(), function (i, val) {
                var $dockModal = $(this);
                var $this = $dockModal.find("." + dClass + "-body > div").data("dockmodal");

                if ($dockModal.hasClass("popped-out") && !$dockModal.hasClass("minimized")) {
                    return;
                }
                right += $this.options.gutter;
                $dockModal.css({ "right": right + "px" });
                if ($dockModal.hasClass("minimized")) {
                    right += $this.options.minimizedWidth;
                } else {
                    right += $this.options.width;
                }
                if (right > windowWidth) {
                    $dockModal.hide();
                } else {
                    setTimeout(function () {
                        $dockModal.show();
                    }, $this.options.animationSpeed);
                }
            });
        }

    };

    $.fn.dockmodal = function (method) {
        if (methods[method]) {
            return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof method === 'object' || !method) {
            return methods.init.apply(this, arguments);
        } else {
            $.error('Method ' + method + ' does not exist on jQuery.dockmodal');
        }
    };
})(jQuery);
