module PuppetDocs

  module Reference

    # Find the special versions that should be symlinked
    def self.special_versions
      listing = {}
      listing[:stable] = generated_versions.detect { |v, dir| v.release_type == :final }
      listing[:latest] = generated_versions.first
      # This looks super hairy, so here's the deal: We have an array of
      # arrays, w/ each internal array containing a Versionomy::Value object and
      # a directory. Whole thing is sorted by the versionomy objects in
      # descending order. Since it's sorted descending, we are guaranteed that:
      #
      # * Every time we see a NEW major.minor value of the version objects,
      #   we're looking at the latest reference from that particular major.minor
      #   series.
      # * Every time we see a NEW major value, we're looking at the latest
      #   reference from that particular major series.
      #
      # So we'll just compare against the previous for both of those, and add
      # each detected new version. This gives us self-maintaining 2.latest,
      # 2.7.latest, etc. links, which is rad.
      #
      # Stable sub-versions are a little trickier. We'll say that moving to a
      # new version series "destabilizes" that type of series. If we're in a
      # destabilized series, we always check to see if it's a final release (not
      # an RC or beta); if it is, we set the stable version, and stabilize. This
      # means we catch the FIRST final release in each series.
      prev_maj_min = "0.0"
      prev_maj     = "0"
      stabilized_maj_min = false
      stabilized_maj     = false
      generated_versions.each do |ver_dir_pair|
        v = ver_dir_pair[0]
        maj_min = "#{v.major}.#{v.minor}"
        maj = "#{v.major}"
        # Handle latest versions, inc. RCs and betas
        if maj_min != prev_maj_min
          listing["#{maj_min}.latest"] = ver_dir_pair
          prev_maj_min = maj_min
          stabilized_maj_min = false
        end
        if maj != prev_maj
          listing["#{maj}.latest"] = ver_dir_pair
          prev_maj = maj
          stabilized_maj = false
        end
        # Handle stable versions
        if !stabilized_maj_min and v.release_type == :final
          listing["#{maj_min}.stable"] = ver_dir_pair
          stabilized_maj_min = true
        end
        if !stabilized_maj and v.release_type == :final
          listing["#{maj}.stable"] = ver_dir_pair
          stabilized_maj = true
        end
      end
      listing
    end

    # A sorted array of [version, path] for non-symlinked version paths
    def self.generated_versions #:nodoc:
      return @generated_versions if @generated_versions
      possibles = generated_version_directories.map do |path|
        [Versionomy.parse(path.basename.to_s), path]
      end
      @generated_versions = possibles.sort_by { |x| x.first }.reverse
    end

    # The valid, non-symlinked version paths
    def self.generated_version_directories #:nodoc:
      children = (PuppetDocs.root + "source/references").children
      possibles = children.select do |child|
        child.directory? && !child.symlink?
      end
    end

  end

end
