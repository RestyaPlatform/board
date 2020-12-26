/**
 * @fileOverview This file has functions related to checklist add form view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model. It contain all card based object @see Available Object in App.CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ChecklistAddForm View
 * @class ChecklistAddFormView
 * @constructor
 * @extends Backbone.View
 */
App.ChecklistAddFormView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.list = options.list;
        this.render();
    },
    template: JST['templates/checklist_add_form'],
    tagName: 'form',
    className: 'js-add-checklist',
    attributes: {
        'method': 'POST'
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            card: this.model,
            list: this.list,
        }));
        this.showTooltip();
        return this;
    }
});
