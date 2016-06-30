/**
 * @fileOverview This file has functions related to card member form view. This view calling from card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model. It contain all card based object @see Available Object in App.CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardMemberForm View
 * @class CardMemberFormView
 * @constructor
 * @extends Backbone.View
 */
App.CardMemberFormView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/card_member_form'],
    tagName: 'div',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.el = this.template({
            card: this.model
        });
        this.showTooltip();
        return this;
    }
});
