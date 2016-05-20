/**
 * @fileOverview This file has functions related to qr code view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Qr Code View
 * @class QrCodeView
 * @constructor
 * @extends Backbone.View
 */
App.QrCodeView = Backbone.View.extend({
    template: JST['templates/qr_code'],
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.render();
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template()).attr('title', i18next.t('View in iOS App'));
        this.$el.dockmodal({
            initialState: 'docked',
            height: 300,
            width: 400,
            animationSpeed: ANIMATION_SPEED
        });
        this.showTooltip();
        return this;
    }
});
