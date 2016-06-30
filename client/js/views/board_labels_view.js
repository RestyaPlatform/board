App.BoardLabelsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
            if (!_.isUndefined(authuser.user) && !_.isUndefined(this.model.board_users)) {
                var board_user_role_id = this.model.board_users.findWhere({
                    user_id: parseInt(authuser.user.id)
                });
                if (!_.isEmpty(board_user_role_id)) {
                    this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
                }
            }
        }
        this.labels = options.labels;
        this.render();
    },
    template: JST['templates/board_labels'],
    tagName: 'li',
    converter: new showdown.Converter(),
    /** 
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-delete-labels': 'deleteLabels'
    },
    deleteLabels: function(e) {
        var label_id = $(e.currentTarget).data('id');
        $('.js-setting-response').html(new App.LabelDeleteConfirmView({
            model: this.model,
            label_id: label_id
        }).el);
        return false;
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
            board: this.model,
            board_labels: this.labels,
            converter: this.converter
        }));
        this.showTooltip();
        return this;
    }
});
