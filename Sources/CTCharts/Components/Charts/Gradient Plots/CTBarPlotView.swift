
import UIKit

/// A graph that displays one or more vertical bar plots.
class CTBarPlotView: CTGradientPlotView<CTBarLayer> {
    
    override func resetLayers() {
        let graphRect = graphBounds()
        let offsets = computeBarOffsets()
        resolveNumberOfLayers()
        dataSeries.enumerated().forEach { index, series in
            let layer = seriesLayers[index]
            layer.dataPoints = series.dataPoints
            layer.horizontalOffset = offsets[index]
            layer.startColor = series.gradientStartColor ?? tintColor
            layer.endColor = series.gradientEndColor ?? tintColor
            layer.barWidth = series.size
            layer.setPlotBounds(rect: graphRect)
            layer.frame = bounds
        }
        super.resetLayers()
    }

    // Adjust the x coordinates of the data series so that the bar charts line up next to one another.
    // This does take into account that bars might have different widths.
    private func computeBarOffsets() -> [CGFloat] {
        let barSizes = dataSeries.map { $0.size }
        let groupWidth = barSizes.reduce(0, +)
        let offset = -groupWidth / 2
        let adjustments = barSizes.enumerated().map { seriesIndex, size -> CGFloat in
            let combinedWidthOfPreviousBars = barSizes[0..<seriesIndex].reduce(0, +)
            let shift = offset + combinedWidthOfPreviousBars + size / 2
            return shift
        }
        return adjustments
    }

    private func resolveNumberOfLayers() {
        while seriesLayers.count < dataSeries.count {
            let newLayer = CTBarLayer()
            seriesLayers.append(newLayer)
            layer.addSublayer(newLayer)
        }
        while seriesLayers.count > dataSeries.count {
            let oldLayer = seriesLayers.removeLast()
            oldLayer.removeFromSuperlayer()
        }
    }
}
