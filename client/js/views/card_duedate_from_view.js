/**
 * @fileOverview This file has functions related to card duedate form view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model. @see Available Object in CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardDuedateFrom View
 * @class CardDuedateFromView
 * @constructor
 * @extends Backbone.View
 */
App.CardDuedateFromView = Backbone.View.extend({
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
    template: JST['templates/card_duedate_from'],
    tagName: 'form',
    className: 'form-horizontal clearfix js-card-edit-form',
    id: 'cardDueDateEditForm',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            card: this.model
        }));
        this.showTooltip();
        return this;
    }
});
