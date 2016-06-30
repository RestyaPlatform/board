/**
 * @fileOverview This file has functions related to card label view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: label model. It contain all card based object @see Available Object in App.CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardLabel View
 * @class CardLabelView
 * @constructor
 * @extends Backbone.View
 */
App.CardLabelView = Backbone.View.extend({
    template: JST['templates/card_label'],
    tagName: 'li',
    className: 'js-card-label-show card-label-show navbar-btn',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {},
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            label: this.model,
            background: this.getLabelcolor('' + this.model.attributes.name).substring(0, 6)
        }));
        this.showTooltip();
        return this;
    },
    /**
     * getLabelcolor()
     * generate color code
     * @param string
     * @type string
     * @return color code
     * @type string
     */
    getLabelcolor: function(string) {
        return calcMD5(string).slice(0, 6);
    },
    /**
     * deleteLabel()
     * delete card label
     * @return false
     *
     */
    deleteLabel: function() {
        this.model.destroy();
        this.model.url = api_url + 'boards/' + this.model.collection.card.get('board_id') + '/lists/' + this.model.collection.card.get('list_id') + '/cards/' + this.model.collection.card.id + '/labels/' + this.model.id + '.json';
        this.$el.remove();
        return false;
    }
});
